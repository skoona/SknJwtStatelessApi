#
# JwtAuthenticator Service
module HandleAuthentication

  def unregister_user(env)
    res = res = SknFailure.({username: "", scopes: []}, "Unregister Failure!")
    auth = Rack::Auth::Basic::Request.new(env)
    if (auth.provided? && auth.basic? && auth.credentials)
      username = auth.credentials[0]
      password = auth.credentials[1]
      res = SknApp.registry.resolve("users-datasource").unregister(username, password)
      if res.success
        SknApp.logger.debug("#{__method__}() #{res.message}")
      end
    end
    res
  rescue => e
    SknApp.logger.warn("#{__method__}() Klass: #{e.class.name}, Msg: #{e.message}, backtrace: #{e.backtrace.first.to_s.split("/").last}")
    SknFailure.({username: username, scopes: []}, "#{e.class.name} -> #{e.message}")
  end

  def register_user(env)
    res = res = SknFailure.({username: "", scopes: []}, "Registration Failure!")
    auth = Rack::Auth::Basic::Request.new(env)
    if (auth.provided? && auth.basic? && auth.credentials)
      username = auth.credentials[0]
      password = auth.credentials[1]
      res = SknApp.registry.resolve("users-datasource").register(username, password)
      if res.success
        SknApp.logger.debug("#{__method__}() #{res.message}")
      end
    end
    res
  rescue => e
    SknApp.logger.warn("#{__method__}() Klass: #{e.class.name}, Msg: #{e.message}, backtrace: #{e.backtrace.first.to_s.split("/").last}")
    SknFailure.({username: username, scopes: []}, "#{e.class.name} -> #{e.message}")
  end

  def validate_user(env)
    res = SknFailure.({username: "", scopes: []}, "Validation Failure!")
    auth = Rack::Auth::Basic::Request.new(env)
    if (auth.provided? && auth.basic? && auth.credentials)
      username = auth.credentials[0]
      password = auth.credentials[1]
      res = SknApp.registry.resolve("users-datasource").authenticate!(username, password)
      username = nil unless res.success # SknSuccess/SknFailure
      scopes   = res.value[:scopes]
      SknApp.logger.debug("#{__method__}() Known User: #{username} roles: #{scopes}")
    end
    res # SknSuccess/SknFailure
  rescue => e
    SknApp.logger.warn("#{__method__}() Klass: #{e.class.name}, Msg: #{e.message}, backtrace: #{e.backtrace.first.to_s.split("/").last}")
    SknFailure.({username: username, scopes: []}, "#{e.class.name} -> #{e.message}")
  end

  def token(res)
    JWT.encode payload(res.value[:username], res.value[:scopes]), SknSettings.idp.secret, 'HS256'
  end

  def payload(username, scopes)
    SknApp.metadata[:jwt_tokens_issued] += 1
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