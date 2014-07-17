require 'spec_helper'

describe Admin::UsersController do

  describe "when an admin user is signed in" do
    before(:each) do
      user = create(:admin_user)
      sign_in(user)
    end

    describe "GET #index" do
      it "returns success" do
        get :index
        expect(response.code).to eq("200")
      end
    end
  end
end