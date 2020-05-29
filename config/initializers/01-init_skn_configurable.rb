# ##
# 00-init_configurable
#
# ******** SknUtils gem automatically creates: SknUtils, SknContainer, and SknSettings ********
#
# Main Business Application

class SknApp
  include ::SknUtils::Configurable.with( :app_id, enable_root: true)

  # - and accept defaults for:
  #   #env=           SknUtils::EnvStringHandler RACK_ENV || development
  #   #root=          SknUtils::EnvStringHandler.new( Dir.pwd )
  #   #registry=      SknRegistry
  #   #romDB=         nil
  #   #logger=        'No Logger Assigned'
  #   #userdata=      nil
  #   #metadata=      nil
  self.metadata = {
      ipl_timestamp: Time.now.getlocal.strftime('%Y-%m-%d %H:%M:%S.%N %z'),
      timestamp: Time.now.getlocal.strftime('%Y-%m-%d %H:%M:%S.%N %z'),
      app_version: Skn::VERSION,
      active_environment: SknApp.env,
      api_version: 'v1',
      admin_events: 0,
      registrations: 0,
      reg_failures: 0,
      unregisters: 0,
      unreg_failures: 0,
      authentications: 0,
      auth_failures: 0,
      not_found_failures: 0,
      account_transactions: 0,
      credential_transactions: 0,
      api_view_money_requests: 0,
      api_add_money_requests: 0,
      api_remove_money_requests: 0,
      jwt_issuer: SknSettings.idp.issuer,
      jwt_token_lifetime: SknSettings.idp.jwt_expires_in_seconds,
      jwt_tokens_issued: 0,
      jwt_audience: SknSettings.idp.audience,
      credentials_storage: File.size?(SknSettings.datasources.credentials),
      accounts_storage: File.size?(SknSettings.datasources.accounts),
      uncaught_exceptions: 0
  }

  configure do
    app_id SknSettings.idp.audience.first
  end

  # reader: true, enable SknApp.logger versus SknApp.config.logger; SknApp.config.logger = <is still required to set value laster>
end
