class TwitterClient
  API_ENDOPOINT = "https://api.twitter.com/1.1/"

  def initialize(personal_token, app_token, oauth_consumer_key, oauth_token, oauth_consume_secret, oauth_token_secret)
    @personal_token = personal_token
    @app_token = app_token
    @oauth_consumer_key = oauth_consumer_key
    @oauth_token = oauth_token
    @oauth_consumer_secret = oauth_consumer_secret
    @oauth_token_secret = oauth_token_secret
  end

  def search(q, count, since_id)
    with_error_handling do
      connection.get("search/tweets.json", app_auth_token_header) do |req|
        req.params["q"] = q
        req.params["count"] = count
      end.body
    en
  end

  def following(user_id)
    with_error_handling do
      api_path = "friends/list.json"
      query_params = {
        user_id: user_id
      }
      connection.get(api_path, user_auth_token_header(api_path, query_params)) do |req|
        req.params = query_params
      end.body
    en
  end

  private
    def connection(endpoint: API_ENDOPOINT, auth_headers:)
      Faraday.new(url: endpoint, headers: auth_headers) do |connection|
        connection.use FaradayMiddleware::FollowRedirects
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

    def app_auth_token_header
      {
        "Authorization": "Bearer #{@app_token}"
      }
    end

    def user_auth_token_header(api_path, query_params)
      oauth_params = {
        oauth_consumer_key: @oauth_consumer_key,
        oauth_nonce: oauth_nonce
        oauth_signature_method: "HMAC-SHA1",
        oauth_timestamp: oauth_timestamp,
        oauth_token: @oauth_token,
        oauth_version: "1.0"
      }
      params = oauth_params.merge(query_params)

      # キーをアルファベット順に昇順ソート
      sorted_params = params.sort { |k1, k2| k1 <=> k2 }.to_h

      # keyとvalueをそれぞれURLエンコーディングし、key=valueで結合した文字列を生成
      params_str = sorted_params.keys.inject("") do |result, key| 
        encoded_key = ERB::Util.url_encode(key.to_s)
        encoded_value = ERB::Util.url_encode(sorted_params[key])
        result += "&" if result.present?
        result += "#{encoded_key}=#{encoded_value}"
      end 

      # シグネチャのベースとなる文字列を生成
      base_str = "POST&#{ERB::Util.url_encode("#{API_ENDOPOINT}#{api_path}")}&#{ERB::Util.url_encode(params_str)}"
      signing_key = "#{ERB::Util.url_encode("#{@oauth_consumer_secret}")}&#{ERB::Util.url_encode("#{@oauth_token_secret}")}"

      # HMAC-SHA1シグネチャを生成
      signature = Base64.strict_encode64(OpenSSL::HMAC.digest("sha1", signing_key, base_str))

      # Authrizationヘッダーのパラメータを設定
      authorization_params = oauth_params.merge({
        oauth_signature: signature
      })

      # Authorizationヘッダーの値を生成
      authorization_str = authorization_params.keys.inject("OAuth") do |result, key|
        encoded_key = ERB::Util.url_encode(key.to_s)
        encoded_value = ERB::Util.url_encode(authorization_params[key])
        if result.equal?("OAuth")
          result += " "
        else
          result += ", " 
        end
        result += "#{encoded_key}=\"#{encoded_value}\""
      end

      {
        "Authorization": authorization_str
      }
    end

    def oauth_timestamp
      Time.now.to_i
    end

    def oauth_nonce
      Base64.encode64(OpenSSL::Random.random_bytes(32)).gsub(/\W/,'')
    end
end
