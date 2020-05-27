class JwtAuthenticator < Roda
  SknApp.logger.debug "Entering #{self.name} as Authenticator!"

  plugin :json
  plugin :json_parser
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
    r.is "status" do
      SknApp.metadata[:credentials_storage] = File.size?(SknSettings.datasources.credentials)
      SknApp.metadata[:accounts_storage] = File.size?(SknSettings.datasources.accounts)
      SknApp.metadata[:timestamp] = Time.now.getlocal.strftime('%Y-%m-%d %H:%M:%S.%N %z')
      {metrics: SknApp.metadata}
    end

    r.is "authenticate" do
      username, scopes = validate_user(request.env)
      if username
        SknApp.metadata[:authentications] += 1
        { token: token(username, scopes) }
      else
        SknApp.metadata[:auth_failures] += 1
        r.halt [  Rack::Utils.status_code(:unauthorized), { 'Content-Type' => 'application/json' }, [{error: 'NotAuthenticated', errorDetails: "Valid authentication credentials are required."}.to_json]]
      end
    end

    r.is "register" do
      username = register_user(request.env)
      if username
        response.status = 202
        SknApp.metadata[:registrations] += 1
        {message: "Registration for #{username} was accepted"}
      else
        SknApp.metadata[:reg_failures] += 1
        r.halt [Rack::Utils.status_code(:bad_request), { 'Content-Type' => 'application/json' }, [{error: 'BadRequest', errorDetails: "Authentication credentials required."}.to_json]]
      end
    end
  end # end route

  def register_user(env)
    username = nil
    auth = Rack::Auth::Basic::Request.new(env)
    if (auth.provided? && auth.basic? && auth.credentials)
      username = auth.credentials[0]
      password = auth.credentials[1]
      if SknApp.registry.resolve("users-datasource").register(username, password)
        SknApp.logger.debug("#{__method__}() Registerd NewUser: #{username}")
      end
    end
    username
  rescue => e
    SknApp.logger.warn("#{__method__}() Klass: #{e.class.name}, Msg: #{e.message}, backtrace: #{e.backtrace.first.to_s.split("/").last}")
    nil
  end

  def validate_user(env)
    username = nil
    scopes = []
    auth = Rack::Auth::Basic::Request.new(env)
    if (auth.provided? && auth.basic? && auth.credentials)
      username = auth.credentials[0]
      password = auth.credentials[1]
      user_scopes = SknApp.registry.resolve("users-datasource").authenticate!(username, password)
      username = nil unless user_scopes && user_scopes.scopes? # SknHash
      scopes = user_scopes && user_scopes.scopes? ? user_scopes.scopes : []
      SknApp.logger.debug("#{__method__}() Known User: #{username} roles: #{scopes}")
    end
    [username, scopes]
  rescue => e
    SknApp.logger.warn("#{__method__}() Klass: #{e.class.name}, Msg: #{e.message}, backtrace: #{e.backtrace.first.to_s.split("/").last}")
    nil
  end

  def token(username, scopes)
    JWT.encode payload(username, scopes), SknSettings.idp.secret, 'HS256'
  end

  def payload(username, scopes)
    {
        exp: Time.now.getlocal.to_i + 60 * 60,
        iat: Time.now.getlocal.to_i,
        nbf: Time.now.getlocal.to_i - 3600,
        iss: SknSettings.idp.issuer,
        aud: SknSettings.idp.audience,
        sub: username,
        scopes: scopes,
        user: {
            username: username
        }
    }
  end

end
