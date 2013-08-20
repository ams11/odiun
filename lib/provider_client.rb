require 'net/http'

module VideoClient
  class ProviderClient
    def get_metadata unique_id
      metadata = {}
      uri = URI.parse(self.get_service_url(unique_id))

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = false

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      if response.is_a?(Net::HTTPOK)
        response_data = JSON.parse(response.body)
        metadata = self.parse_metadata(response_data) unless response_data.blank?
      else
        metadata[:error] = self.parse_error response.body
      end

      metadata
    end
  end
end