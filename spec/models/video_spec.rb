# == Schema Information
#
# Table name: videos
#
#  id                  :integer          not null, primary key
#  url                 :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  name                :string(255)
#  provider            :integer
#  unique_id           :integer
#  visible             :boolean          default(FALSE)
#  thumbnail_url       :string(255)
#  user_id             :integer
#  featured            :boolean          default(FALSE)
#  large_thumbnail_url :string(255)
#  genre_id            :integer
#  score_total         :integer          default(0)
#  max_score           :integer          default(0)
#

require "spec_helper"

describe Video do
  let(:video) { create(:video) }

  subject { video }

  it { should have_many(:user_votes) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:unique_id) }
  it { should validate_presence_of(:genre) }

  it "should set featured flag to flase by default" do
    video.featured.should be false
  end
end
