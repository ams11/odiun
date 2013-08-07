require 'spec_helper'

describe VideosController do
  describe "GET #new" do
    it "returns success" do
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
    let(:description) { "Oh, the Places You'll Go at Burning Man!" }

    it "creates a new Video" do
      params = { :video => { :url => url,
                             :description => description }}
      expect { post :create, params }.to change(Video, :count).by(1)
    end
  end


end