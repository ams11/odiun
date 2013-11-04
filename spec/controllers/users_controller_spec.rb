require 'spec_helper'

describe UsersController do
  let(:user) { create(:voter_user) }

  describe "GET #dashboard" do
    it "returns success" do
      sign_in user
      get :dashboard, :user_id => user.id
      expect(response.code).to eq("200")
    end
  end

  describe "GET #vote" do
    it "returns success" do
      sign_in user
      get :vote, :user_id => user.id
      expect(response.code).to eq("200")
    end
  end
end