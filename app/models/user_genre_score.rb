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

class UserGenreScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :genre
  has_one    :primary_user, :class_name => "User"

  scope      :totals,   -> { where(score_type: UserGenreScore::TOTAL) }

  WATCHED = "videos_watched"
  ORIGINAL = "original_selection"
  PERSONAL = "personal_content"
  TOTAL = "total"

  validates_presence_of :score, :user, :genre, :score_type
  validates :score_type, inclusion: %w(videos_watched original_selection personal_content total)
  validates_inclusion_of :score, in: 0.00..100.00

  def self.score_types
    [WATCHED, ORIGINAL, PERSONAL, TOTAL]
  end
end
