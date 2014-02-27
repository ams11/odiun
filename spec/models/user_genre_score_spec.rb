# == Schema Information
#
# Table name: user_genre_scores
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  genre_id    :integer          not null
#  score       :decimal(10, 4)   default(0.0)
#  score_type  :string(255)      not null
#  video_count :integer
#

require 'spec_helper'

describe UserGenreScore do
  let(:user_genre_score) { create(:user_genre_score) }

  subject { user_genre_score }

  it { should validate_presence_of(:score) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:genre) }
  it { should validate_presence_of(:score_type) }
  it { should belong_to(:user) }
  it { should belong_to(:genre) }

  %w(videos_watched original_selection personal_content total).each do |score_type|
    it "should validate inclusion of #{score_type}" do
      user_genre_score = UserGenreScore.new(:score_type => score_type)
      user_genre_score.save
      user_genre_score.errors[:score_type].should be_blank
    end
  end

  %w(videos_watch foo bar).each do |score_type|
    it "should validate exclusion of #{score_type}" do
      user_genre_score = UserGenreScore.new(:score_type => score_type)
      user_genre_score.save
      user_genre_score.errors[:score_type].should_not be_blank
    end
  end

end
