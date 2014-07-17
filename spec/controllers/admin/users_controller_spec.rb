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

    describe "GET #show" do
      it "redirects to the edit page" do
        user = create(:user)

        get :show, :id => user.id
        response.should redirect_to(edit_admin_user_path(user.id))
      end
    end

    describe "GET #edit" do
      it "returns success" do
        user = create(:user)

        get :edit, :id => user.id
        expect(response.code).to eq("200")
      end

      it "redirects to users#index for an invalid user" do
        user = create(:user)

        get :edit, :id => user.id + rand(1000..1100)
        response.should redirect_to(admin_users_path)
      end
    end
  end
end