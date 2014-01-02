require 'spec_helper'

describe UsersController do
  let(:simple_user) { create(:user) }
  let(:user) { create(:voter_user) }
  let(:admin_user) { create(:admin_user) }

  [:dashboard, :vote].each do |action|
    describe "GET #{action.to_s}" do
      it "returns success" do
        sign_in user
        get action, :user_id => user.id
        expect(response.code).to eq("200")
      end

      it "redirects to home when requesting an invalid user's dashboard" do
        sign_in user
        get action, :user_id => user.id + rand(1000..1100)
        response.should redirect_to(root_path)
      end

      it "redirects to home when requesting a different user's dashboard" do
        sign_in user
        get action, :user_id => create(:user).id
        response.should redirect_to(root_path)
      end

      it "redirects to home when a non-voter user requests their dashboard" do
        sign_in simple_user
        get action, :user_id => simple_user.id
        response.should redirect_to(edit_user_registration_path)
      end

      it "redirects to the sign in page if no user is signed in" do
        get action, :user_id => user.id
        response.should redirect_to(new_user_session_path)
      end
    end
  end
end