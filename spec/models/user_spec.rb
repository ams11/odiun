require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  subject { user }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:videos) }

  describe "#vote_videos" do
    it "returns some videos" do
      videos = user.vote_videos
      videos.should_not be nil

      pending "implement a voting suggestion algorithm and test for it!"
    end
  end
end
