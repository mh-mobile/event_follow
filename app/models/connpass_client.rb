# frozen_string_literal: true

class ConnpassClient
  API_ENDOPOINT = "https://connpass.com/api/v1"

  def initialize
  end

  def search(event_id)
    with_error_handling do
      connection.get("event/?event_id=#{event_id}").body
    end
  end

  private
    def connection(endpoint: API_ENDOPOINT)
      Faraday.new(url: endpoint, headers: nil) do |connection|
        connection.request :url_encoded
        connection.response :mashify, mash_class: EventResponse
        connection.response :json
        connection.response :raise_error

        connection.adapter Faraday.default_adapter
      end
    end

    def with_error_handling
      yield
    rescue Faraday::ClientError, Faraday::ServerError => error
      begin
        body = JSON.parse(error.response[:body])
        raise EventResponse, body["message"]
      rescue JSON::ParserError
        raise error
      end
    end
end
