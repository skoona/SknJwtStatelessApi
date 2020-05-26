require 'json'
require 'jwt'
require 'roda'
require_relative 'user'
require_relative 'jwt_auth_filter'
require_relative 'jwt_stateless_api'
require_relative 'jwt_authenticator'

# ENV['JWT_ISSUER']
# ENV['JWT_SECRET']
# JWT_SECRET=sknSuperSecrets JWT_ISSUER=skoona.net be puma ./config.ru  -p 8080
