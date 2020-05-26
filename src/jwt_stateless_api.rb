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
