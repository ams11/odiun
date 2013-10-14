require 'spec_helper'

describe VideosController do

  describe "GET #new" do
    it "returns success" do
      sign_in
      get :new
      expect(response.code).to eq("200")
    end
  end

  describe "GET #index" do
    it "returns success" do
      get :index
      expect(response.code).to eq("200")
    end
  end

  describe "GET #show" do
    video = FactoryGirl.create(:video)
    params = { :id => video.id }

    it "returns success" do
      get :show, params
      expect(response.code).to eq("200")
    end
  end

  describe "POST #create" do
    let(:url) { "http://www.youtube.com/embed/YIwE-ECjbx8" }

    it "creates a new Video" do
      sign_in FactoryGirl.create(:user)
      params = { :video => { :url => url } }
      expect { post :create, params }.to change(Video, :count).by(1)
    end
  end

  describe "POST #toggle_feature" do
    let(:video) { create(:video, :user => create(:user)) }

    it "can change the featured status" do
      sign_in video.user
      video.featured.should be false      # initially, :feature should default to false

      # check that we can toggle to true
      post :toggle_feature, :video_id => video.id
      video_update = Video.find_by_id video.id
      video_update.featured.should be true

      # check that we can toggle back to false
      post :toggle_feature, :video_id => video.id
      video_update = Video.find_by_id video.id
      video_update.featured.should be false
    end
  end

  describe "POST #vote" do
    let(:video) { create(:video) }

    it "can change the video rating" do
      sign_in video.user

      post :vote, :video_id => video.id, :video => { :score => 75 }
      response.should redirect_to(video_path(video))
      video.reload
      video.score.should == 75
    end

    it "does not update the score if the vote value is invalid" do
      sign_in video.user
      old_score = video.score

      post :vote, :video_id => video.id, :video => { :score => 101 }
      response.should render_template("videos/show")
      video.reload
      video.score.should == old_score
    end

    it "redirects to videos path for an invalid video id" do
      post :vote, :video_id => video.id + rand(1000..2000), :video => { :score => 75 }
      response.should redirect_to(videos_path)
    end
  end


end