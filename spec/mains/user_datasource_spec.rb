
# Ref: http://testing-for-beginners.rubymonstas.org/rack_test/rack.html
# Ref: http://tutorials.jumpstartlab.com/topics/capybara/capybara_with_rack_test.html

RSpec.describe UserDatasource, "Local Registration and Account Storage. " do
  let(:service) {described_class.instance}
  let(:creds) {SknSettings.defaults.registrations}
  let(:accts) {SknSettings.defaults.accounts}

  before :each do
    service.send(:filesystem_refresh, true)
  end

  context "Core Operations" do
    before :each do
      service.send(:filesystem_refresh, true)
    end
    context "Credentials" do
      it "Add" do
        crd = {username: "someuser",
               password: "someuser pwd",
               scopes: ["view_only"]
        }
        expect(service.credentials_add(crd)).to be true
        expect(service.authenticate!("someuser","someuser pwd")).to be_a SknSuccess
      end
      it "Save" do
        crd = {username: "newuser",
               password: "newuser pwd",
               scopes: ["view_only"]
        }
        expect(service.send(:credentials_save,crd)).to be true
        expect(service.authenticate!("newuser","newuser pwd")).to be_a SknSuccess
      end
      it "Delete" do
        crd = creds[:emowner].to_hash
        expect(service.send(:credentials_delete,crd)).to be true
        expect(service.authenticate!(crd[:username],crd[:password])).to be_a SknFailure
      end
      it "Restore" do
        expect(service.send(:credentials_restore)).to be_a Hash
      end
    end

    context "Accounts" do
      it "Add" do
        crd = {username: "someuser", balance: 1200}
        expect(service.accounts_add(crd)).to be true
        expect(service.account_for("someuser").value[:balance]).to eq 1200
      end
      it "Save" do
        crd = {username: "someuser",
               balance: 1200
        }
        expect(service.send(:accounts_save,crd)).to be true
        expect(service.account_for("someuser").value[:balance]).to eq 1200
      end
      it "Delete" do
        crd = {username: "emuser",
               balance: 1200
        }
        expect(service.send(:accounts_delete, crd)).to be true
        expect(service.account_for(crd[:username]).value[:balance]).to eq 0
      end
      it "Restore" do
        expect(service.send(:accounts_restore)).to be_a Hash
      end
    end
  end

  context "Application UseCases" do
    before :each do
      service.send(:filesystem_refresh, true)
    end

    it "Register User. " do
      expect(service.register("newuser", "newuser pwd", ["view_only"])).to be_a SknSuccess
    end
    it "Unregister User. " do
      crd = SknHash.new(creds[:emowner].to_hash)
      expect(service.unregister(crd.username, crd.password)).to be_a SknSuccess
    end
    it "Account for User. " do
      crd = SknHash.new(accts[:emowner].to_hash)
      expect(service.account_for(crd.username)).to be_a SknSuccess
    end
    it "Update Account. " do
      crd = SknHash.new(accts[:emowner].to_hash)
      expect(service.account_update_for(crd.username, 1000)).to be_a SknSuccess
    end
    it "Authenticate Credentials. " do
      crd = SknHash.new(creds[:emuser].to_hash)
      expect(service.authenticate!(crd.username, crd.password)).to be_a SknSuccess
      expect(service.authenticate!(crd.username, "Suzy")).to be_a SknFailure
    end
  end
end
