# ##
# 01-init_configuration.rb
#
# This creates a global constant (and singleton) with a defaulted configuration
# See config/settings.yml, config/settings/*.yml, and config/settings/*.local.yml
# Source: skn_utils.gem lib/skn_utils/configuration.rb
#
# ******** SknUtils gem automatically creates: SknUtils, SknContainer, and SknSettings ********
#

if RUBY_PLATFORM == "java"
  if defined?($servlet_context)

    value = java.lang.System.getenv('JWT_REGISTRATION_STORE')
    SknSettings.datasources.registration = value unless value.nil?

    value = java.lang.System.getenv('JWT_ACCOUNTS_STORE')
    SknSettings.datasources.accounts = value unless value.nil?

    value = java.lang.System.getenv('JWT_SECRET')
    SknSettings.idp.secret = value unless value.nil?

    value = java.lang.System.getenv('JWT_ISSUER')
    SknSettings.idp.issuer = value unless value.nil?

    $stdout.puts("Using Real Environment Values.")
  end
end
