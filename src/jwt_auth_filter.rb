class JwtAuthFilter
  def initialize app
    @app = app
  end

  def call env
    if env[:user]
      @app.call env
    else
      options = { algorithm: 'HS256', iss: ENV['JWT_ISSUER'], verify_iss: true, aud: "InternalUseOnly", verify_aud: true }
      bearer = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
      payload, header = JWT.decode bearer, ENV['JWT_SECRET'], true, options
      env[:user] = User.(payload.dig('user', 'username'), payload['scopes'])
      puts "JwtAuthFilter() Payload=#{payload}, Header=#{header}"
      @app.call env
    end

  rescue JWT::ExpiredSignature
    [403, { 'Content-Type' => 'application/json' }, [{error: 'ExpiredSignature', errorDetails: 'The token has expired.'}.to_json]]
  rescue JWT::InvalidIssuerError
    [403, { 'Content-Type' => 'application/json' }, [{error: 'InvalidIssuerError', errorDetails: 'The token does not have a valid issuer.'}.to_json]]
  rescue JWT::InvalidIatError
    [403, { 'Content-Type' => 'application/json' }, [{error: 'InvalidIatError', errorDetails: 'The token does not have a valid "issued at" time.'}.to_json]]
  rescue JWT::InvalidAudError
    [403, { 'Content-Type' => 'application/json' }, [{error: 'InvalidAudError', errorDetails: 'The token was not authorized for this "audience".'}.to_json]]
  rescue JWT::DecodeError => e
    [401, { 'Content-Type' => 'application/json' }, [{error: 'DecodeError', errorDetails: "A valid token must be passed! #{e.message}"}.to_json]]
  rescue => e
    [403, { 'Content-Type' => 'application/json' }, [{error: e.class.name, errorDetails: e.message}.to_json]]
  end
end
