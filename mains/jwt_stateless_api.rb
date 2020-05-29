##
# Endpoints
#
class JwtStatelessApi < Roda
  include HandleStateless

  SknApp.logger.debug "Entering #{self.name} as Application! Path: (/api/v1/[money,admin])"

  use JwtAuthFilter

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

    r.is 'money' do
      r.get do
        SknApp.metadata[:api_view_money_requests] += 1
        process_request request, 'view_money' do |req, username|
          { money: account_balance_for(username) }
        end
      end

      r.post do
        SknApp.metadata[:api_add_money_requests] += 1
        process_request request, 'add_money' do |req, username|
          amount = req[:amount]
          new_amount = ( account_balance_for(username) + amount.to_i )
          account_update_for(username, new_amount)
          { money: new_amount }
        end
      end

      r.delete do
        SknApp.metadata[:api_remove_money_requests] += 1
        process_request request, 'remove_money' do |req, username|
          amount = request[:amount]
          new_amount = (account_balance_for(username) - amount.to_i)
          if new_amount < 0
            new_amount = 0
          end
          account_update_for(username, new_amount)
          { money: new_amount }
        end
      end
    end

    r.is 'admin' do
      r.put  do # {username: "", scopes: ""} -- update_roles
        SknApp.metadata[:admin_events] += 1
        process_request request, 'admin' do |req, username|
          res = accounts.credentials_update_for({username: r.params["username"], scopes: r.params["scopes"]})
          res.value.to_hash
        end
      end

      r.get  do # list all
        SknApp.metadata[:admin_events] += 1
        process_request request, 'admin' do |req, username|
          res = accounts.list_credentials(username)
          res.value.to_hash
        end
      end
    end

  end # end routes
end # end app
