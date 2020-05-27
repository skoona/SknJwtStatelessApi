require_relative 'user'
require_relative 'jwt_authenticator'
require_relative 'jwt_auth_filter'
require_relative 'jwt_stateless_api'
require_relative 'user_datasource'

##
# DataSource
SknApp.registry.register("users-datasource", ->() { UserDatasource.instance } , call: true)

SknApp.logger.info "SknJwtStatelessApi Serving the #{SknApp.config.app_id} audience."