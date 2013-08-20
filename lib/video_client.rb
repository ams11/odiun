require 'net/http'
require 'youtube_client'
require 'vimeo_client'

module VideoClient
  def get_video_metadata_from_provider type, unique_id
    unique_id.sub!(/\?.*$/, "")
    client = case type
      when :vimeo
        VimeoClient.new
      when :youtube
        YoutubeClient.new
    end

    client.get_metadata unique_id
  end

  def match_url url
    youtube_regexes = YoutubeClient.get_regexes
    vimeo_regexes = VimeoClient.get_regexes

    if url.match(youtube_regexes[:share]).nil?   # youtube direct 'share' link
      if url.match(youtube_regexes[:browser]).nil?    # youtube browser url
        if url.match(youtube_regexes[:embed]).nil?    # youtube embed url
          if url.match(vimeo_regexes[:share]).nil?     # vimeo direct link
            if url.match(vimeo_regexes[:embed]).nil?    # vimeo embed link
              type = nil
              unique_id = nil
            else
              type = :vimeo
              unique_id = url.sub(vimeo_regexes[:embed], "")
            end
          else
            type = :vimeo
            unique_id = url.sub(vimeo_regexes[:share], "")
            unless !!(unique_id =~ /^[-+]?[1-9]([0-9]*)?$/)     # find the redirect if the url is in the http://vimeo.com/user/video_name format
              unique_id = VimeoClient.get_redirect_url(unique_id)
              unique_id.sub!("/", "") unless unique_id.blank?
            end
          end
        else
          type = :youtube
          unique_id = url.sub(youtube_regexes[:embed], "")
        end
      else
        type = :youtube
        unique_id = url.sub(youtube_regexes[:browser], "").split("&")[0]
      end
    else
      type = :youtube
      unique_id = url.sub(youtube_regexes[:share], "")
    end

    return type, unique_id

  end
end