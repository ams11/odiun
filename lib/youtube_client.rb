require 'provider_client'

module VideoClient
  class YoutubeClient < ProviderClient

    SHARE_LINK_REGEX = /^.*\/\/youtu.be\//                        # Youtube Share link, e.g.        http://youtu.be/XXXXXXXX
    BROWSER_URL_REGEX = /^.*\/\/(www|m).youtube.com\/watch\?/   # Youtube browser url, e.g.       http://www.youtube.com/watch?v=XXXXXXXX (or mobile url: http://m.youtube.com/watch?v=XXXXXXXX)
    EMBED_URL_REGEX = /^.*\/\/www.youtube.com\/embed\//           # Youtube browser embed url, e.g. http://www.youtube.com/embed/XXXXXXXX

    def get_service_url unique_id
      "http://gdata.youtube.com/feeds/api/videos/#{unique_id}?v=2&prettyprint=true&alt=json"
    end

    def parse_metadata response_data
      id = response_data["entry"]["media$group"]["yt$videoid"]["$t"]
      mq_index = response_data["entry"]["media$group"]["media$thumbnail"].index { |thumbnail| thumbnail["yt$name"] == "mqdefault"}
      sdd_index = response_data["entry"]["media$group"]["media$thumbnail"].index { |thumbnail| thumbnail["yt$name"] == "sddefault"}
      embed_permission_index = response_data["entry"]["yt$accessControl"].index {|a| a["action"] == "embed"}

      data = { :id => id,
        :url => "http://www.youtube.com/embed/#{id}?rel=0",
        :name => response_data["entry"]["media$group"]["media$title"]["$t"],
        :description => response_data["entry"]["media$group"]["media$description"]["$t"],
        :thumbnail => response_data["entry"]["media$group"]["media$thumbnail"][mq_index]["url"],
        :thumbnail_large => (response_data["entry"]["media$group"]["media$thumbnail"][sdd_index]["url"] rescue nil),
        :allow_embed => (response_data["entry"]["yt$accessControl"][embed_permission_index]["permission"] == "allowed")
      }

      data[:thumbnail_large] = data[:thumbnail] if data[:thumbnail_large].blank?
      data
=begin    parsing format for the condensed response (&alt=jsonc)
      { :id => response_data["data"]["id"],
        :url => "http://www.youtube.com/embed/#{response_data["data"]["id"]}?rel=0",
        :name => response_data["data"]["title"],
        :description => response_data["data"]["description"],
        :thumbnail => response_data["data"]["thumbnail"]["hqDefault"]
      }
=end
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