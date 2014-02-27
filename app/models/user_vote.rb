# == Schema Information
#
# Table name: user_votes
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  video_id        :integer
#  score_emotion   :integer
#  score_intellect :integer
#  score_entertain :integer
#

class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :user, :video, :score_emotion, :score_intellect, :score_entertain
  validates_numericality_of :score_emotion, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 100.0, :message => I18n.t('errors.videos.invalid_rating')
  validates_numericality_of :score_intellect, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 100.0, :message => I18n.t('errors.videos.invalid_rating')
  validates_numericality_of :score_entertain, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 100.0, :message => I18n.t('errors.videos.invalid_rating')
end
