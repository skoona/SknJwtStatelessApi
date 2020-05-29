##
# Endpoints
#
class JwtAuthenticator < Roda
  include HandleAuthentication

  SknApp.logger.debug "Entering #{self.name} as Application! Path: (/[status,authenticate,register,unregister])"

  plugin :json
  plugin :json_parser
  plugin :all_verbs
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
      res = validate_user(request.env)
      if res.success
        SknApp.metadata[:authentications] += 1
        { token: token(res) }
      else
        SknApp.metadata[:auth_failures] += 1
        r.halt [  Rack::Utils.status_code(:unauthorized), { 'Content-Type' => 'application/json' }, [{error: 'NotAuthenticated', errorDetails: "Valid authentication credentials are required. [#{res.message}]"}.to_json]]
      end
    end

    r.is "register" do
      res = register_user(request.env)
      if res.success
        response.status = 202
        SknApp.metadata[:registrations] += 1
        {message: res.message}
      else
        SknApp.metadata[:reg_failures] += 1
        r.halt [Rack::Utils.status_code(:bad_request), { 'Content-Type' => 'application/json' }, [{error: 'BadRequest', errorDetails: "Authentication credentials required. [#{res.message}]"}.to_json]]
      end
    end

    r.is "unregister" do
      r.delete do
        res = unregister_user(request.env)
        if res.success
          response.status = 202
          SknApp.metadata[:unregisters] += 1
          {message: res.message}
        else
          SknApp.metadata[:unreg_failures] += 1
          r.halt [Rack::Utils.status_code(:bad_request), { 'Content-Type' => 'application/json' }, [{error: 'BadRequest', errorDetails: "Authentication credentials required. [#{res.message}]"}.to_json]]
        end
      end
    end

  end # end routes
end # End app
