
# Ref: http://testing-for-beginners.rubymonstas.org/rack_test/rack.html
# Ref: http://tutorials.jumpstartlab.com/topics/capybara/capybara_with_rack_test.html

RSpec.describe "Stateless API Responds Correctly. " do

  RSpec.shared_examples 'Money API with JWT' do
    before :each do
      apply_user_authentication(auth_token)
    end
    it "GET /api/v1/money succeeds. " do
      get "/api/v1/money"
      expect(last_response).to be_successful
    end
    it "POST /api/v1/money?amount=50 succeeds. " do
      post "/api/v1/money", {params: {amount: 50}}

      if :emuser == auth_user
        expect(last_response).to be_forbidden
      else
        expect(last_response).to be_successful
      end
    end
    it "DELETE /api/v1/money?amount=50 succeeds. " do
      delete "/api/v1/money", {params: {amount: 50}}
      if :emowner == auth_user
        expect(last_response).to be_successful
      else
        expect(last_response).to be_forbidden
      end
    end
  end

  RSpec.shared_examples 'Money API without JWT' do
    it "GET /api/v1/money is not authenticated. " do
      get "/api/v1/money"
      expect(last_response).to be_unauthorized
    end
    it "POST /api/v1/money?amount=50 is not authenticated. " do
      post "/api/v1/money", {params: {amount: 50}}
      expect(last_response).to be_unauthorized
    end
    it "DELETE /api/v1/money?amount=50 is not authenticated. " do
      delete "/api/v1/money", {params: {amount: 50}}
      expect(last_response).to be_unauthorized
    end
  end

  context "Authenticator" do
    context "JWT Authentication" do
      it "returns http success" do
        authorize('emowner', 'emowner pwd')
        post "/authenticate"
        expect(last_response).to be_successful
        expect(last_response.body).to include("token")
      end
      it "returns http Unauthorized" do
        post "/authenticate"
        expect(last_response).to be_unauthorized
      end
    end

    context "Register " do
      it "returns http success" do
        authorize('newuser', 'new user pwd')
        post "/register"
        expect(last_response).to be_successful
        expect(last_response.body).to include("newuser")

        authorize('newuser', 'new user pwd')
        post "/authenticate"
        expect(last_response).to be_successful
      end
      it "returns http Unauthorized" do
        post "/register"
        expect(last_response).to be_bad_request
      end
    end

    context "Unregister " do
      it "returns http success" do
        authorize('newreg', 'newreg pwd')
        post "/register"
        expect(last_response).to be_successful
        expect(last_response.body).to include("newreg")

        authorize('newreg', 'newreg pwd')
        delete "/unregister"
        expect(last_response).to be_successful
        expect(last_response.body).to include("newreg")
      end
      it "returns http Unauthorized" do
        delete "/unregister"
        expect(last_response).to be_bad_request
      end
    end

    context "Application Status" do
      it "returns available metrics" do
        post "/status"
        expect(last_response).to be_successful
        expect(last_response.body).to include("timestamp")
      end
      it "returns available metrics on any http verb" do
        get "/status"
        expect(last_response).to be_successful
        puts last_response.body
        expect(last_response.body).to include("timestamp")
      end
    end
  end

  context "Application" do
    context "Honors JWT Operations for emowner. " do
      it_behaves_like 'Money API with JWT' do
        let(:auth_token) { authorizing_token('emowner', 'emowner pwd') }
        let(:auth_user) { :emowner }
      end
      it_behaves_like 'Money API without JWT'
    end

    context "Honors JWT Operations for emkeeper. " do
      it_behaves_like 'Money API with JWT' do
        let(:auth_token) { authorizing_token('emkeeper', 'emkeeper pwd') }
        let(:auth_user) { :emkeeper }
      end
      it_behaves_like 'Money API without JWT'
    end

    context "Honors JWT Operations for emuser. " do
      it_behaves_like 'Money API with JWT' do
        let(:auth_token) { authorizing_token('emuser', 'emuser pwd') }
        let(:auth_user) { :emuser }
      end
      it_behaves_like 'Money API without JWT'
    end
  end
end
