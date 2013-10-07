require 'spec_helper'

describe "the home page", :type => :feature do
  subject { page }

  before :each do
    @videos = []
    [1..3].each do
      @videos << create(:video)
    end
  end

  it "visits the home page" do
    visit root_path

    pending "temporary disabled"

    @videos.each do |video|
      should have_xpath "//a[@href=\"#{video_url(video)}\"]"
    end
  end
end