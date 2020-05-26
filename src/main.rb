require 'json'
require 'jwt'
require 'roda'

# ENV['JWT_ISSUER']
# ENV['JWT_SECRET']
# JWT_SECRET=sknSuperSecrets JWT_ISSUER=skoona.net be puma ./config.ru  -p 8080

class User

  attr_reader :last_access, :username, :roles

  def self.call(username, scopes)
    self.new.with_username(username).with_roles(scopes)
  end

  def with_username(value)
    @username = value
    self
  end
  def with_roles(value)
    @roles = value
    self
  end

  private

  def initialize
    @last_access = Time.now.getlocal
  end

end

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


class JwtStatelessApi < Roda
  use JwtAuthFilter
  plugin :json
  plugin :json_parser
  plugin :all_verbs
  plugin :halt

  plugin :not_found do |req|
    {error: "Not Found", errorDetails: "#{req.request_method} #{req.remaining_path}"}
  end

  plugin :error_handler do |exc|
    {error: exc.class.name, errorDetails: exc.message, errorRef: exc.backtrace.first.to_s.split("/").last}
  end

  @@_accounts = {
      emowner: 10000,
      emuser: 50000,
      emkeeper: 1000000000
  }

  route do |r|
    puts "Entered API Route via #{r.request_method} #{r.remaining_path}"
    r.is 'money' do
      r.get do
        process_request request, 'view_money' do |req, username|
          { money: accounts[username] }
        end
      end
      r.post do
        process_request request, 'add_money' do |req, username|
          amount = req[:amount]
          accounts[username] += amount.to_i
          { money: accounts[username] }
        end
      end
      r.delete do
        process_request request, 'remove_money' do |req, username|
          amount = request[:amount]
          accounts[username] -= amount.to_i
          if accounts[username] < 0
            accounts[username] = 0
          end
          { money: accounts[username] }
        end
      end
    end
  end # end route

  def accounts
    @@_accounts
  end

  def current_user(request)
    if self.instance_variable_defined?("@_user")
      @_user
    else
      @_user = request.env[:user]
    end
  end

  def process_request req, scope
    if current_user(req).roles.include?(scope) && accounts.has_key?(current_user(req).username.to_sym)
      yield req, current_user(req).username.to_sym
    else
      req.halt [403, { 'Content-Type' => 'application/json' }, [{error: 'NotAuthorized', errorDetails: "You are not authorized to access: #{scope}"}.to_json]]
    end
  end

end


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
