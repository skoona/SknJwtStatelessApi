module JwtHelpers

  # Returns provided token
  def apply_user_authentication(token)
    header( 'Authorization', "Bearer #{token}" )
    token
  end

  # Returns just the token raw value
  def authorizing_token(username, password)
    token = ""
    authorize(username, password)
    post "/authenticate" do |response|
      token = JSON.parse(response.body)["token"]
    end
    token
  end

  # Returns JWT Token
  def authenticate_user(username, password)
    token = authorizing_token(username, password)
    apply_user_authentication(token)
  end

  # Returns JWT Token
  def register_and_authenticate_user(username, password)
    authorize(username, password)
    post '/register'
    authenticate_user(username, password)
  end

end