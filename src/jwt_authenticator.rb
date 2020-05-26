class JwtAuthenticator < Roda

  puts "Enter Public"
  plugin :json
  plugin :json_parser
  plugin :halt

  plugin :not_found do |req|
    {error: "Not Found", errorDetails: "#{req.request_method} #{req.remaining_path}"}
  end

  plugin :error_handler do |exc|
    {error: exc.class.name, errorDetails: exc.message, errorRef: exc.backtrace.first.to_s.split("/").last}
  end

  @@_logins = {
      emowner: {password: 'emowner pwd', scopes: ['add_money', 'remove_money', 'view_money']},
      emuser: {password: 'emuser pwd', scopes: ['view_money']},
      emkeeper: {password: 'emkeeper pwd', scopes: ['add_money', 'view_money']}
  }

  route do |r|
    puts "Entered Authorization Route via #{r.request_method} #{r.remaining_path}"
    r.on "authenticate" do
      username = validate_user(request.env)
      if username
        { token: token(username) }
      else
        r.halt [401, { 'Content-Type' => 'application/json' }, [{error: 'NotAuthenticated', errorDetails: "Valid authentication credential are required."}.to_json]]
      end
    end
  end # end route

  def logins
    @@_logins
  end

  def validate_user(env)
    username = nil
    auth = Rack::Auth::Basic::Request.new(env)
    if (auth.provided? && auth.basic? && auth.credentials)
      username = auth.credentials[0]
      password = auth.credentials[1]
      username = nil unless logins[username.to_sym][:password] == password
    end
    username
  end

  def token(username)
    JWT.encode payload(username), ENV['JWT_SECRET'], 'HS256'
  end

  def payload(username)
    {
        exp: Time.now.getlocal.to_i + 60 * 60,
        iat: Time.now.getlocal.to_i,
        nbf: Time.now.getlocal.to_i - 3600,
        iss: ENV['JWT_ISSUER'],
        aud: ["InternalUseOnly"],
        sub: username,
        scopes: ( logins.dig(username.to_sym,:scopes) || [] ) ,
        user: {
            username: username
        }
    }
  end

end
