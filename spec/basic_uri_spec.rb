
# Ref: http://testing-for-beginners.rubymonstas.org/rack_test/rack.html
# Ref: http://tutorials.jumpstartlab.com/topics/capybara/capybara_with_rack_test.html

RSpec.describe "Stateless API Responds Correctly. " do
  def authenticated_basic(username, password)
    token = ""
    authorize(username, password)
    post "authenticate" do |response|
      token = JSON.parse(response.body)["token"]
    end
    { Authorization: "Bearer #{token}" }
  end

  RSpec.shared_examples 'Money API with JWT' do
    before :each do
      header("Authorization", auth_token[:Authorization])
    end
    it "GET /api/v1/money succeeds. " do
      get "/api/v1/money", {params: {}}
      expect(last_response.status).to eq 200
    end
    it "POST /api/v1/money?amount=50 succeeds. " do
      post "/api/v1/money", {params: {amount: 50}}

      if :emuser == auth_user
        expect(last_response.status).to eq 403
      else
        expect(last_response.status).to eq 200
      end
    end
    it "DELETE /api/v1/money?amount=50 succeeds. " do
      delete "/api/v1/money", {params: {amount: 50}}
      if :emowner == auth_user
        expect(last_response.status).to eq 200
      else
        expect(last_response.status).to eq 403
      end
    end
  end

  RSpec.shared_examples 'Money API without JWT' do
    it "GET /api/v1/money is not authenticated. " do
      get "/api/v1/money", {params: {}}
      expect(last_response.status).to eq 401
    end
    it "POST /api/v1/money?amount=50 is not authenticated. " do
      post "/api/v1/money", {params: {amount: 50}}
      expect(last_response.status).to eq 401
    end
    it "DELETE /api/v1/money?amount=50 is not authenticated. " do
      delete "/api/v1/money", {params: {amount: 50}}
      expect(last_response.status).to eq 401
    end
  end

  context "JWT Authentication" do
    it "returns http success" do
      authorize('emowner', 'emowner pwd')
      post "/authenticate"
      expect(last_response.status).to eq 200
      expect(last_response.body).to include("token")
    end
    it "returns http Unauthorized" do
      post "/authenticate"
      expect(last_response.status).to eq 401
    end
  end

  context "Honors JWT Operations for emowner. " do
    it_behaves_like 'Money API with JWT' do
      let(:auth_token) { authenticated_basic('emowner', 'emowner pwd') }
      let(:auth_user) { :emowner }
    end
    it_behaves_like 'Money API without JWT'
  end

  context "Honors JWT Operations for emkeeper. " do
    it_behaves_like 'Money API with JWT' do
      let(:auth_token) { authenticated_basic('emkeeper', 'emkeeper pwd') }
      let(:auth_user) { :emkeeper }
    end
    it_behaves_like 'Money API without JWT'
  end

  context "Honors JWT Operations for emuser. " do
    it_behaves_like 'Money API with JWT' do
      let(:auth_token) { authenticated_basic('emuser', 'emuser pwd') }
      let(:auth_user) { :emuser }
    end
    it_behaves_like 'Money API without JWT'
  end

end
