require 'spec_helper'

describe Admin::VideosController do

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

  describe "when an admin user isn't signed in" do
    describe "GET #index" do
      it "redirects to the sign in page when no user signed in" do
        get :index
        response.should redirect_to(new_user_session_path)
      end

      it "redirects to the sign in page when user signed in isn't an admin" do
        sign_in(create(:user))
        get :index
        response.should redirect_to(root_path)
      end
    end
  end
end
