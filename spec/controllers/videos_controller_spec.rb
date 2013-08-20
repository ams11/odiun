require 'spec_helper'

describe VideosController do

  before(:each) do
    User.delete_all
  end

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


end