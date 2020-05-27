class UserDatasource
  include Singleton
  ##
  # Hash with Key for each user
  ##
  SknApp.logger.debug "Entering #{self.name} as Database!"

  def register(username, password, roles=false)
    credentials = {
        username: username,
        password: password,
        scopes: (roles || SknSettings.defaults.scopes)
    }
    account = {
        username: username,
        balance: 0
    }
    credentials_add(credentials)
    accounts_add(account)
  rescue => e
    msg =  "#{self.class.name}##{__method__} Create Failed: klass=#{e.class.name}, cause=#{e.message}, Backtrace=#{e.backtrace[0..4]}"
    SknApp.logger.warn(msg)
    false
  end

  def unregister(username)
    credentials = {username: username}
    account = {username: username}

    credentials_delete(credentials)
    accounts_delete(account)
  rescue => e
    msg =  "#{self.class.name}##{__method__} Create Failed: klass=#{e.class.name}, cause=#{e.message}, Backtrace=#{e.backtrace[0..4]}"
    SknApp.logger.warn(msg)
    false
  end

  # return scopes/roles if valid else nil
  def authenticate!(username, password)
    value = nil
    creds = @_credentials[username.to_sym]
    if !!creds && creds[:password].eql?(password)
      value = creds.fetch(:scopes, [])
      SknHash.new( {scopes: value} )
    else
      nil
    end
  end

  def account_for(username)
    acct = @_accounts[username.to_sym]
    value = acct.nil? ? 0 : acct.fetch(:balance, 0)
    SknHash.new( balance: value )
  end
  def account_update_for(username, new_balance)
    if @_accounts.member?(username.to_sym)
      accounts_save({username: username, balance: new_balance})
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
      ds = credentials_ds
      key = value[:username].to_sym
      if !!ds.transaction {|tx| tx[key] = value }
        @_credentials[key] = value
        true  # no leaking objects
      end
    else
      false
    end
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, with inputData: [#{value}]"
    false
  end
  def credentials_delete(value)
    if value[:username]
      ds = credentials_ds
      key = value[:username].to_sym
      if !!@_credentials.delete(key)
        ds.transaction {|tx| tx.delete(key) }
        true
      end
    else
      false
    end
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, with inputData: [#{value}]"
    false
  end

  def accounts_save(value)
    if value[:username]
      ds = accounts_ds
      key = value[:username].to_sym
      if !!ds.transaction {|tx| tx[key] = value }
        @_accounts[key] = value
        true
      end
    else
      false
    end
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, with inputData: [#{value}]"
    false
  end
  def accounts_delete(value)
    if value[:username]
      ds = accounts_ds
      key = value[:username].to_sym
      if !!@_accounts.delete(key)
        !!ds.transaction {|tx| tx.delete(key) }
      end
      true
    else
      false
    end
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }, with inputData: [#{value}]"
    false
  end

  def credentials_ds
    SknApp.metadata[:credential_transactions] += 1
    ds =YAML::Store.new(SknSettings.datasources.credentials, true)
    ds.ultra_safe = true
    ds
  end
  def accounts_ds
    SknApp.metadata[:account_transactions] += 1
    ds = YAML::Store.new(SknSettings.datasources.accounts, true)
    ds.ultra_safe = true
    ds
  end

  def credentials_restore(override=false)
    pkg = {}
    if override
      IO.binwrite( SknSettings.datasources.credentials, SknSettings.defaults.registrations.to_hash.to_yaml)
    end
    ds = credentials_ds
    ds.transaction(true) do |tx|
      tx.roots.each do |username_key|
        pkg[username_key] = tx[username_key]
      end
    end
    @_credentials = pkg
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }"
    nil
  end

  def accounts_restore(override=false)
    pkg = {}
    if override
      IO.binwrite( SknSettings.datasources.accounts, SknSettings.defaults.accounts.to_hash.to_yaml)
    end
    ds = accounts_ds
    ds.transaction(true) do |tx|
      tx.roots.each do |username_key|
        pkg[username_key] = tx[username_key]
      end
    end
    @_accounts = pkg
  rescue => e
    SknApp.logger.warn "#{self.class.name}##{__method__}: #{e.class} causedBy #{ e.message }"
    nil
  end

  def filesystem_refresh(override=false)
    if override || (!File.exist?(SknSettings.datasources.credentials) || (File.size?(SknSettings.datasources.credentials).to_i < 10))
      credentials_restore true
      accounts_restore true
    else
      credentials_restore
      accounts_restore
    end
  end

  def initialize
    super
    filesystem_refresh
  end
end