##
#
# JwtStatelessApi Service
module HandleStateless

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

  def admin_delete_user(username)
    res = res = SknFailure.({username: "", scopes: []}, "Unregister Failure!")
    if username
      res = SknApp.registry.resolve("users-datasource").admin_delete(username)
      SknApp.logger.debug("#{__method__}() #{res.message}")
    end
    res
  rescue => e
    SknApp.logger.warn("#{__method__}() Klass: #{e.class.name}, Msg: #{e.message}, backtrace: #{failure_lines(e)}")
    SknFailure.({username: username, scopes: []}, "#{e.class.name} -> #{e.message}, backtrace: #{failure_lines(e)}")
  end


  ##
  # Handle API Actions
  def process_request req, scope
    authorized = if scope.is_a?(Array)
      scope.any? {|scp| current_user(req).roles.include?(scp)}
    else
      current_user(req).roles.include?(scope)
    end

    if authorized && account_for(current_user(req).username).success
      yield req, current_user(req).username
    else
      req.halt [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: 'NotAuthorized', errorDetails: "You are not authorized to access: #{scope}"}.to_json]]
    end
  rescue => e
    SknApp.logger.warn("#{__method__}() Klass: #{e.class.name}, Msg: #{e.message}, backtrace: #{failure_lines(e)}")
    req.halt [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: e.class.name, errorDetails: e.message}.to_json]]
  end
end