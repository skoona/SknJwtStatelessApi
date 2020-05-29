class JwtAuthFilter
  SknApp.logger.debug "Entering #{self.name} as JWT Filter!"

  def initialize app
    @app = app
  end

  def call env
    if env[:user]
      @app.call env
    else
      options = { algorithm: 'HS256', iss: SknSettings.idp.issuer, verify_iss: true, aud: SknSettings.idp.audience.first, verify_aud: true }
      bearer = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
      payload, header = JWT.decode bearer, SknSettings.idp.secret, true, options

      env[:user] = User.(payload.dig('user', 'username'), payload['scopes'])

      @app.call env
    end

  rescue JWT::ExpiredSignature => e
    SknApp.logger.warn("#{self.class.name}() klass: #{e.class}, Msg: #{e.message}")
    [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: 'ExpiredSignature', errorDetails: 'The token has expired.'}.to_json]]
  rescue JWT::InvalidIssuerError => e
    SknApp.logger.warn("#{self.class.name}() klass: #{e.class.name}, Msg: #{e.message}")
    [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: 'InvalidIssuerError', errorDetails: 'The token does not have a valid issuer.'}.to_json]]
  rescue JWT::InvalidIatError => e
    SknApp.logger.warn("#{self.class.name}() klass: #{e.class.name}, Msg: #{e.message}")
    [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: 'InvalidIatError', errorDetails: 'The token does not have a valid "issued at" time.'}.to_json]]
  rescue JWT::InvalidAudError => e
    SknApp.logger.warn("#{self.class.name}() klass: #{e.class.name}, Msg: #{e.message}")
    [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: 'InvalidAudError', errorDetails: 'The token was not authorized for this "audience".'}.to_json]]
  rescue JWT::DecodeError  => e
    SknApp.logger.warn("#{self.class.name}() klass: #{e.class.name}, Msg: #{e.message}")
    [Rack::Utils.status_code(:unauthorized), { 'Content-Type' => 'application/json' }, [{error: 'DecodeError', errorDetails: "A valid token must be passed! #{e.message}"}.to_json]]
  rescue  => e
    SknApp.logger.warn("#{self.class.name}() klass: #{e.class.name}, Msg: #{e.message}")
    [Rack::Utils.status_code(:forbidden), { 'Content-Type' => 'application/json' }, [{error: e.class.name, errorDetails: e.message}.to_json]]
  end
end
