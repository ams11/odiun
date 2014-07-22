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

    describe "GET #show" do
      it "redirects to the edit page" do
        video = create(:video)

        get :show, :id => video.id
        response.should redirect_to(edit_admin_video_path(video.id))
      end
    end

    describe "GET #edit" do
      it "returns success" do
        video = create(:video)

        get :edit, :id => video.id
        expect(response.code).to eq("200")
      end

      it "redirects to videos#index for an invalid video" do
        video = create(:video)

        get :edit, :id => video.id + rand(1000..1100)
        response.should redirect_to(admin_videos_path)
      end
    end

    describe "POST #approve" do
      it "can change the approved flag to true" do
        pending "add test"
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
