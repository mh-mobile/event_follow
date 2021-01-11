# frozen_string_literal: true

class TwitterClient
  include TwitterAuthorization

  def initialize(app_token:, oauth_consumer_key:, oauth_token:, oauth_consumer_secret:, oauth_token_secret:)
    @app_token = app_token
    @oauth_consumer_key = oauth_consumer_key
    @oauth_token = oauth_token
    @oauth_consumer_secret = oauth_consumer_secret
    @oauth_token_secret = oauth_token_secret
  end

  def search(q:, count: SEARCH_COUNT, max_id: nil, since_id: nil)
    with_error_handling do
      connection(auth_headers: app_auth_token_header).get("search/tweets.json") do |req|
        req.params["q"] = q
        req.params["count"] = count
        req.params["max_id"] = max_id if max_id
        req.params["since_id"] = since_id if since_id
        req.params["tweet_mode"] = "extended"
      end.body
    end
  end

  def retweets(tweet_id:, count: RETWEETS_COUNT)
    with_error_handling do
     connection(auth_headers: app_auth_token_header).get("statuses/retweets/#{tweet_id}.json") do |req|
       req.params["count"] = count
       req.params["tweet_mode"] = "extended"
     end.body
   end
  end

  def following(count: FRIENDS_LIST_COUNT, cursor: "-1")
    with_error_handling do
      api_path = "friends/list.json"
      query_params = {
        count: count,
        cursor: cursor
      }
      connection(auth_headers: user_auth_token_header(api_path, query_params)).get(api_path) do |req|
        req.params = query_params
      end.body
    end
  end

  def verify_credentials
    with_error_handling do
      api_path = "account/verify_credentials.json"
      query_params = {}
      connection(auth_headers: user_auth_token_header(api_path, query_params)).get(api_path) do |req|
        req.params = query_params
      end.body
    end
  end

  private
    def connection(endpoint: API_ENDOPOINT, auth_headers:)
      Faraday.new(url: endpoint, headers: auth_headers) do |connection|
        connection.use FaradayMiddleware::FollowRedirects
        connection.request :url_encoded
        connection.response :mashify, mash_class: EventResponse
        connection.response :json
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
        raise error if error.response[:status] == 404
        body = JSON.parse(error.response[:body])
        raise EventResponse, body["message"]
      rescue JSON::ParserError
        raise error
      end
    end
end
