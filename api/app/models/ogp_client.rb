# frozen_string_literal: true

class OgpClient
  attr_reader :body

  def search(event_url)
    @endpoint = event_url
    with_error_handling do
      response = connection.get("")
      @body = response.body
      OGP::OpenGraph.new(response.body)
    end
  end

  private
    def connection(endpoint: @endpoint)
      Faraday.new(url: endpoint, headers: nil) do |connection|
        connection.use FaradayMiddleware::FollowRedirects
        connection.response :raise_error
        if Rails.env.development?
          connection.request :curl, Logger.new(STDOUT), :debug
          connection.response :logger, Logger.new(STDOUT)
        end
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
