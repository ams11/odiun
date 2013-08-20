require 'provider_client'

module VideoClient
  class VimeoClient < ProviderClient

    SHARE_LINK_REGEX = /^.*\/\/vimeo.com\//
    EMBED_LINK_REGEX = /^.*\/\/player.vimeo.com\/video\//

    def get_service_url unique_id
      "http://vimeo.com/api/v2/video/#{unique_id}.json"
    end

    def parse_metadata response_data
      { :id => response_data[0]["id"],
        :url => "http://player.vimeo.com/video/#{response_data[0]["id"]}",
        :name => response_data[0]["title"],
        :description => response_data[0]["description"],
        :thumbnail => response_data[0]["thumbnail_large"]
       }
    end

    def parse_error response_body
      response_body
    end

    def self.get_redirect_url unique_id
      http = Net::HTTP.start('vimeo.com')
      resp = http.head("/#{unique_id}")
      resp["location"]
    end

    def self.get_regexes
      { :share => SHARE_LINK_REGEX,
        :embed => EMBED_LINK_REGEX }
    end
  end
end