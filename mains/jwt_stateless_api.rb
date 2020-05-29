class JwtStatelessApi < Roda
  SknApp.logger.debug "Entering #{self.name} as Application!"

  use JwtAuthFilter

  plugin :json
  plugin :json_parser
  plugin :all_verbs
  plugin :halt

  plugin :not_found do |req|
    SknApp.metadata[:not_found_failures] += 1
    {error: "Not Found", errorDetails: "#{req.request_method} #{req.remaining_path}"}
  end

  plugin :error_handler do |exc|
    SknApp.metadata[:uncaught_exceptions] += 1
    {error: exc.class.name, errorDetails: exc.message, errorRef: exc.backtrace.first.to_s.split("/").last}
  end

  route do |r|
    SknApp.logger.debug("Entering #{self.class.name} Routes via #{r.request_method} #{r.remaining_path}")

    r.is 'money' do
      r.get do
        SknApp.metadata[:api_view_money_requests] += 1
        process_request request, 'view_money' do |req, username|
          { money: account_balance_for(username) }
        end
      end
      r.post do
        SknApp.metadata[:api_add_money_requests] += 1
        process_request request, 'add_money' do |req, username|
          amount = req[:amount]
          new_amount = ( account_balance_for(username) + amount.to_i )
          account_update_for(username, new_amount)
          { money: new_amount }
        end
      end
      r.delete do
        SknApp.metadata[:api_remove_money_requests] += 1
        process_request request, 'remove_money' do |req, username|
          amount = request[:amount]
          new_amount = (account_balance_for(username) - amount.to_i)
          if new_amount < 0
            new_amount = 0
          end
          account_update_for(username, new_amount)
          { money: new_amount }
        end
      end
    end

    r.is 'admin' do
      r.put  do # {username: "", scopes: ""} -- update_roles
        SknApp.metadata[:admin_events] += 1
        process_request request, 'admin' do |req, username|
          res = accounts.credentials_update_for({username: r.params["username"], scopes: r.params["scopes"]})
          res.value.to_hash
        end
      end
      r.get  do # list all
        SknApp.metadata[:admin_events] += 1
        process_request request, 'admin' do |req, username|
          res = accounts.list_credentials(username)
          res.value.to_hash
        end
      end
    end
  end # end route

  ##
  # Interface to Storage Systenm
  def account_update_for(username, new_balance) # SknSuccess
    accounts.account_update_for(username, new_balance)
  end
  def account_balance_for(username)
    account_for(username).value[:balance]
  end
  def account_for(username) # SknSuccess
    accounts.account_for(username)
  end
  def accounts
    @_db ||= SknApp.registry.resolve("users-datasource")
  end

  ##
  # Interface to JWT Authenticator thru env
  def current_user(request)
    @_user ||= request.env[:user]
  end

  ##
  # Handle API Actions
  def process_request req, scope
    if current_user(req).roles.include?(scope) && account_for(current_user(req).username).success
      yield req, current_user(req).username
    else
      req.halt [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: 'NotAuthorized', errorDetails: "You are not authorized to access: #{scope}"}.to_json]]
    end
  rescue => e
    SknApp.logger.warn("#{__method__}() Klass: #{e.class.name}, Msg: #{e.message}, backtrace: #{e.backtrace.first.to_s.split("/").last}")
    req.halt [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: e.class.name, errorDetails: e.message}.to_json]]
  end

end
