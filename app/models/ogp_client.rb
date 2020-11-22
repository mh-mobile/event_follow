# frozen_string_literal: true

class OgpClient
  def initialize
  end

  def search(event_url)
    @endpoint = event_url
    with_error_handling do
      response = connection.get("")
      open_graph = OGP::OpenGraph.new(response.body)
    end
  end

  private
    def connection(endpoint: @endpoint)
      Faraday.new(url: endpoint, headers: nil) do |connection|
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
