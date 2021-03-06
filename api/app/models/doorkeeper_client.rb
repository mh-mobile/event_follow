# frozen_string_literal: true

class DoorkeeperClient
  API_ENDOPOINT = "https://api.doorkeeper.jp/"

  def initialize(token)
    @token = token
  end

  def search(event_id)
    with_error_handling do
      connection.get("events/#{event_id}").body
    end
  end

  private
    def connection(endpoint: API_ENDOPOINT)
      Faraday.new(url: endpoint, headers: auth_token_headers) do |connection|
        connection.use FaradayMiddleware::FollowRedirects
        connection.request :url_encoded
        connection.response :mashify, mash_class: EventResponse
        connection.response :json
        if Rails.env.development?
          connection.request :curl, Logger.new(STDOUT), :debug
          connection.response :logger, Logger.new(STDOUT)
        end
        connection.response :raise_error

        connection.adapter Faraday.default_adapter
      end
    end

    def with_error_handling
      yield
    rescue Faraday::ClientError, Faraday::ServerError => error
      begin
        raise error if error.response[:status] == 404
        body = JSON.parse(error.response[:body])
        raise error, body["message"]
      rescue JSON::ParserError
        raise error
      end
    end

    def auth_token_headers
      { "Authorization" => "Bearer #{@token}" }
    end
end
