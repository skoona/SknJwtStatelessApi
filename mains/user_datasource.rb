class UserDatasource
  include Singleton
  ##
  # Hash with Key for each user
  ##
  SknApp.logger.debug "Entering #{self.name} as Database!"

  def register(username, password, roles=false)
    scopes = (roles || SknSettings.defaults.scopes)
    credentials = {
        username: username,
        password: password,
        scopes: scopes
    }
    account = {
        username: username,
        balance: 0
    }
    if credentials_add(credentials) && accounts_add(account)
      SknSuccess.({username: username, scopes: scopes},"Registered #{username} with #{scopes} Succeeded!")
    else
      SknFailure.({username: username, scopes: scopes}, "Registration of #{username} with #{scopes} failed!")
    end
  rescue => e
    msg =  "#{self.class.name}##{__method__} Create Failed: klass=#{e.class.name}, cause=#{e.message}, Backtrace: #{failure_lines(e)}"
    SknApp.logger.warn(msg)
    SknFailure.({username: username, scopes: []}, "#{e.class.name} -> #{e.message}")
  end

  def admin_delete(username)
    options = {username: username}
    if username
      if credentials_delete(options) && accounts_delete(options)
        SknSuccess.({username: username, scopes: []},"Unregister #{username} Succeeded!")
      else
        SknFailure.({username: username, scopes: []}, "Unregister #{username} failed!")
      end
    else
      SknFailure.({username: username, scopes: []}, "Unregister #{username} failed!")
    end
  rescue => e
    msg =  "#{self.class.name}##{__method__} Failed: klass=#{e.class.name}, cause=#{e.message}, Backtrace: #{failure_lines(e)}"
    SknApp.logger.warn(msg)
    SknFailure.({username: username, scopes: []}, "#{e.class.name} -> #{e.message}")
  end

  def unregister(username, password)
    options = {username: username, password: password}
    auth = authenticate!(username, password)
    if auth.success
      if credentials_delete(options) && accounts_delete(options)
        SknSuccess.({username: username, scopes: []},"Unregister #{username} Succeeded!")
      else
        SknFailure.({username: username, scopes: []}, "Unregister #{username} failed!")
      end
    else
      auth
    end
  rescue => e
    msg =  "#{self.class.name}##{__method__} Failed: klass=#{e.class.name}, cause=#{e.message}, Backtrace: #{failure_lines(e)}"
    SknApp.logger.warn(msg)
    SknFailure.({username: username, scopes: []}, "#{e.class.name} -> #{e.message}")
  end

  # return scopes/roles if valid else nil
  def authenticate!(username, password)
    value = nil
    creds = @_credentials[username.to_sym]
    if !!creds && creds[:password].eql?(password)
      value = creds.fetch(:scopes, [])
      SknSuccess.( {username: username, scopes: value} )
    else
      SknFailure.({username: username, scopes: []}, "Invalid Credentials #{username}")
    end
  rescue => e
    msg =  "#{self.class.name}##{__method__} Failed: klass=#{e.class.name}, cause=#{e.message}, Backtrace: #{failure_lines(e)}"
    SknApp.logger.warn(msg)
    SknFailure.({username: username, scopes: []}, "#{e.class.name} -> #{e.message}")
  end

  def account_for(username)
    acct = @_accounts[username.to_sym]
    if acct.nil?
      SknFailure.({balance: 0}, "Account Lookup Failed for #{username}" )
    else
      SknSuccess.({balance: acct.fetch(:balance, 0)} )
    end
  end
  def account_update_for(username, new_balance)
    if @_accounts.member?(username.to_sym)
      if accounts_save({username: username, balance: new_balance})
        SknSuccess.({username: username, balance: new_balance})
      else
        SknFailure.({username: username, balance: new_balance}, "$#{new_balance} Account Update Failed for #{username}")
      end
    end
  end

  def credentials_update_for(value) # {username: "", scopes: [all-new-values]}
    if @_credentials.member?(value[:username].to_sym)
      merged = @_credentials[value[:username].to_sym].merge!(value) # pickup password and other value, since its designed for scopes originally
      if credentials_save(merged)
        SknSuccess.(value)
      else
        SknFailure.(value, "Scopes Updated Failed for #{value[:username]}")
      end
    else
      SknFailure.(value, "#{username} is not a existing user.")
    end
  end

  def list_credentials(username)
    if @_credentials.member?(username.to_sym)
        SknSuccess.(
            users: @_credentials.values.map {|user| {username: user[:username], scopes: user[:scopes]} }
        )
    else
        SknFailure.({username: username}, "#{username} is not Authorized for this action.")
    end
  end

  def credentials_add(value)
    key = value[:username]
    credentials_save(value) unless @_credentials.member?(key)
    true  # no leaking objects
  end

  def accounts_add(value)
    key = value[:username]
    accounts_save(value) unless @_accounts.member?(key)
    true  # no leaking objects
  end

  private

  def credentials_save(value)
    if value[:username]
      key = value[:username].to_sym
      if !!credentials_ds {|ds| ds.transaction {|tx| tx[key] = value }}
        @_credentials[key] = value
        true  # no leaking objects
      end
    else
      false
    end
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, with inputData: [#{value}], Backtrace: #{failure_lines(e)}"
    false
  end
  def credentials_delete(value)
    if value[:username]
      key = value[:username].to_sym
      if !!@_credentials.delete(key)
        credentials_ds {|ds| ds.transaction {|tx| tx.delete(key) }}
        true
      end
    else
      false
    end
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, with inputData: [#{value}], Backtrace: #{failure_lines(e)}"
    false
  end

  def accounts_save(value)
    if value[:username]
      key = value[:username].to_sym
      if !!accounts_ds {|ds| ds.transaction {|tx| tx[key] = value }}
        @_accounts[key] = value
        true
      end
    else
      false
    end
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, with inputData: [#{value}], Backtrace: #{failure_lines(e)}"
    false
  end
  def accounts_delete(value)
    if value[:username]
      key = value[:username].to_sym
      if !!@_accounts.delete(key)
        !!accounts_ds {|ds| ds.transaction {|tx| tx.delete(key) }}
      end
      true
    else
      false
    end
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, with inputData: [#{value}], Backtrace: #{failure_lines(e)}"
    false
  end

  def credentials_ds
    @__creds.synchronize do
      SknApp.metadata[:credential_transactions] += 1
      ds =YAML::Store.new(SknSettings.datasources.credentials, true)
      ds.ultra_safe = true
      if block_given?
        yield ds
      else
        ds
      end
    rescue => e
      SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, Backtrace: #{failure_lines(e)}"
      false
    end
  end
  def accounts_ds
    @__accts.synchronize do
      SknApp.metadata[:account_transactions] += 1
      ds = YAML::Store.new(SknSettings.datasources.accounts, true)
      ds.ultra_safe = true
      if block_given?
        yield ds
      else
        ds
      end
    rescue => e
      SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, Backtrace: #{failure_lines(e)}"
      false
    end
  end

  def credentials_restore(override=false)
    pkg = {}
    if override
      IO.binwrite( SknSettings.datasources.credentials, SknSettings.defaults.registrations.to_hash.to_yaml)
    end
    credentials_ds do |ds| ds.transaction(true) do |tx|
        tx.roots.each do |username_key|
          pkg[username_key] = tx[username_key]
        end
      end
    end
    @_credentials = pkg
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, Backtrace: #{failure_lines(e)}"
    nil
  end

  def accounts_restore(override=false)
    pkg = {}
    if override
      IO.binwrite( SknSettings.datasources.accounts, SknSettings.defaults.accounts.to_hash.to_yaml)
    end
    accounts_ds do |ds| ds.transaction(true) do |tx|
        tx.roots.each do |username_key|
          pkg[username_key] = tx[username_key]
        end
      end
    end
    @_accounts = pkg
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, Backtrace: #{failure_lines(e)}"
    nil
  end

  def filesystem_refresh(override=false)
    @_only_one.synchronize do
      if override || (!File.exist?(SknSettings.datasources.credentials) || (File.size?(SknSettings.datasources.credentials).to_i < 10))
        credentials_restore true
        accounts_restore true
      else
        credentials_restore
        accounts_restore
      end
    rescue => e
      SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, Backtrace: #{failure_lines(e)}"
      nil
    end
  end

  def failure_lines(e)
    failures = e.backtrace.map {|x| x.split("/").last }.join(",")
  end

  def initialize
    @_only_one = Mutex.new
    @__creds = Mutex.new
    @__accts = Mutex.new
    super
    filesystem_refresh
  end
end