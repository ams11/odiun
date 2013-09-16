require 'spec_helper'

describe UsersController do

  describe "GET #dashboard" do
    let(:user) { create(:voter_user) }

    it "returns success" do
      sign_in user
      get :dashboard, :user_id => user.id
      expect(response.code).to eq("200")
    end
  end
end