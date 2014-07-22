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
#  provider            :string(255)
#  unique_id           :string(255)
#  visible             :boolean          default(FALSE)
#  thumbnail_url       :string(255)
#  user_id             :integer
#  featured            :boolean          default(FALSE)
#  large_thumbnail_url :string(255)
#  genre_id            :integer
#  score_total         :integer          default(0)
#  max_score           :integer          default(0)
#  approved            :boolean          default(FALSE)
#

require 'video_client'

include VideoClient

class Video < ActiveRecord::Base

  validates_presence_of :name, :url, :unique_id, :user, :genre
  validates_numericality_of :score_total, :max_score, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 100.0, :message => I18n.t('errors.videos.invalid_rating'), :allow_nil => true
  validates_uniqueness_of :unique_id, :scope => [:provider], :message => I18n.t('errors.videos.already')

  belongs_to :user
  belongs_to :genre
  has_many :user_votes

  scope :featured,     -> { where(featured: true) }
  scope :approved,     -> { where(approved: true) }
  scope :unapproved,   -> { where(approved: false) }

  acts_as_commentable

  def get_score
    return 0.00 if self.max_score <= 0
    self.score_total.to_d / self.max_score.to_d
  end

  def show_score
    (self.get_score * 100 / 3).round
  end

  def update_vote vote_value, user
    user_genre_score = UserGenreScore.totals.where(:user => user, :genre => self.genre).limit(1).first
    if user_genre_score.nil?
      delta = 0.1
    else
      delta = user_genre_score.score / user.primary_score
    end
    delta = 1.0 if delta > 1.0
    modified_vote = delta * vote_value + (1.0 - delta) * (self.get_score) * 10
    self.score_total += (modified_vote * user.rank.rank)
    self.max_score += (10 * user.rank.rank)
    self.save
  end

  def update_video! video_params, genre
    url = video_params[:url]
    type, unique_id = match_url(url)

    if type.nil? || unique_id.nil?
      self.errors.add(:url, I18n.t('errors.videos.url_invalid'))
    else
      video_data = get_video_metadata_from_provider(type, unique_id)

      video_data[:error] = I18n.t('errors.videos.cant_embed') if video_data[:allow_embed].present? && !video_data[:allow_embed]
      if video_data.blank? || video_data[:error].present?
        self.errors.add(:url, "#{I18n.t('errors.video.invalid')}. #{video_data[:error] || I18n.t('errors.videos.no_provider_data')}")
      else
        self.update_attributes!(:url => video_data[:url],
                               :name => video_data[:name],
                               :description => video_data[:description],
                               :thumbnail_url => video_data[:thumbnail],
                               :large_thumbnail_url => video_data[:thumbnail_large],
                               :unique_id => video_data[:id],
                               :provider => type.to_s,
                               :genre => genre)
      end
    end
  end

  def self.create_video video_params, genre, user
    url = video_params[:url]
    type, unique_id = match_url(url)

    if type.nil? || unique_id.nil?
      video = Video.new
      video.errors.add(:url, I18n.t('errors.videos.url_invalid'))
    else
      video_data = get_video_metadata_from_provider(type, unique_id)

      if video_data.blank? || video_data[:error].present?
        video = Video.new
        video.errors.add(:url, "#{I18n.t('errors.videos.invalid')}: #{video_data[:error] || I18n.t('errors.videos.no_provider_data')}")
      else
        video = Video.create(:url => video_data[:url],
                             :name => video_data[:name],
                             :description => video_data[:description],
                             :thumbnail_url => video_data[:thumbnail],
                             :large_thumbnail_url => video_data[:thumbnail_large],
                             :unique_id => video_data[:id],
                             :provider => type.to_s,
                             :genre => genre,
                             :user => user)

        # upgrade the guest user to rank 1 after they upload their first video
        # TODO(alex) - temp code. This needs to only happen after an admin has approved this video!!
        user.upgrade_rank if video.valid?
      end
    end

    video
  end

end
