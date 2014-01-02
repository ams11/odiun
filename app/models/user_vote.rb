class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :user, :video, :score
  validates_numericality_of :score, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 100.0, :message => I18n.t('errors.videos.invalid_rating')
end