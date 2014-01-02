# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  rank_id                :integer
#  genre_id               :integer
#  videos_watched_count   :integer
#  user_genre_score_id    :integer
#

require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  subject { user }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:videos) }
  it { should have_many(:user_votes) }
  it { should have_many(:user_genre_scores) }

  describe "#vote_videos" do
    it "returns some videos" do
      videos = user.vote_videos
      videos.should_not be nil

      pending "implement a voting suggestion algorithm and test for it!"
    end
  end
end
