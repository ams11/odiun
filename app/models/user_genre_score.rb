# == Schema Information
#
# Table name: user_genre_scores
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  genre_id   :integer          not null
#  score      :decimal(10, 4)   default(0.0)
#  score_type :string(255)      not null
#

class UserGenreScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :genre

  validates_presence_of :score, :user, :genre, :score_type
  validates :score_type, inclusion: %w(watched original personal)
end
