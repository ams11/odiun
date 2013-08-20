require 'provider_client'

module VideoClient
  class YoutubeClient < ProviderClient

    SHARE_LINK_REGEX = /^.*\/\/youtu.be\//
    BROWSER_URL_REGEX = /^.*\/\/www.youtube.com\/watch\?v=/
    EMBED_URL_REGEX = /^.*\/\/www.youtube.com\/embed\//

    def get_service_url unique_id
      "http://gdata.youtube.com/feeds/api/videos/#{unique_id}?v=2&prettyprint=true&alt=jsonc"
    end

    def parse_metadata response_data
      { :id => response_data["data"]["id"],
        :url => "http://www.youtube.com/embed/#{response_data["data"]["id"]}?rel=0",
        :name => response_data["data"]["title"],
        :description => response_data["data"]["description"],
        :thumbnail => response_data["data"]["thumbnail"]["hqDefault"]
      }
    end

    def parse_error response_body
      JSON.parse(response_body)["error"]["message"] rescue ""
    end

    def self.get_regexes
      { :share => SHARE_LINK_REGEX,
        :browser => BROWSER_URL_REGEX,
        :embed => EMBED_URL_REGEX }
    end
  end
end