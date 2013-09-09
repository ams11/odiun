require 'video_client'

include VideoClient

class Video < ActiveRecord::Base

  validates_presence_of :name, :url, :unique_id, :user

  belongs_to :user

  scope :featured,   -> { where(featured: true) }

  def update_video! video_params
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
                               :provider => type.to_s)
      end
    end
  end

  def self.create_video video_params, user
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
                             :user => user)
      end
    end

    video
  end

end
