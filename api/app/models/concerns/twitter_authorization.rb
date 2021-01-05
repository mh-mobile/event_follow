# frozen_string_literal: true

module TwitterAuthorization
  API_ENDOPOINT = "https://api.twitter.com/1.1/"
  SEARCH_COUNT = 100
  FRIENDS_LIST_COUNT = 200
  RETWEETS_COUNT = 100

  def app_auth_token_header
    {
      "Authorization": "Bearer #{@app_token}"
    }
  end

  def user_auth_token_header(api_path, query_params)
    oauth_params = generate_oauth_params
    params = oauth_params.merge(query_params)

    # キーをアルファベット順に昇順ソート
    sorted_params = sort_params(params)

    # keyとvalueをそれぞれURLエンコーディングし、key=valueで結合した文字列を生成
    params_str = encode_params(sorted_params)

    # HMAC-SHA1シグネチャを生成
    signature = generate_signature_key(api_path, params_str)

    # Authrizationヘッダーのパラメータを設定
    authorization_params = oauth_params.merge({
      oauth_signature: signature
    })

    # Authorizationヘッダーの値を生成
    generate_authorization_header(authorization_params)
  end

  def oauth_timestamp
    Time.now.to_i
  end

  def oauth_nonce
    Base64.encode64(OpenSSL::Random.random_bytes(32)).gsub(/\W/, "")
  end

  def generate_oauth_params
    {
      oauth_consumer_key: @oauth_consumer_key,
      oauth_nonce: oauth_nonce,
      oauth_signature_method: "HMAC-SHA1",
      oauth_timestamp: oauth_timestamp,
      oauth_token: @oauth_token,
      oauth_version: "1.0"
    }
  end

  def sort_params(params)
    params.sort { |k1, k2| k1 <=> k2 }.to_h
  end

  def encode_params(params)
    params.keys.inject("") do |result, key|
      encoded_key = ERB::Util.url_encode(key.to_s)
      encoded_value = ERB::Util.url_encode(params[key])
      result += "&" if result.present?
      result += "#{encoded_key}=#{encoded_value}"
    end
  end

  def generate_signature_key(api_path, query)
    # シグネチャのベースとなる文字列を生成
    base_str = "GET&#{ERB::Util.url_encode("#{API_ENDOPOINT}#{api_path}")}&#{ERB::Util.url_encode(query)}"
    signing_key = "#{ERB::Util.url_encode("#{@oauth_consumer_secret}")}&#{ERB::Util.url_encode("#{@oauth_token_secret}")}"

    Base64.strict_encode64(OpenSSL::HMAC.digest("sha1", signing_key, base_str))
  end

  def generate_authorization_header(authorization_params)
    sorted_params = sort_params(authorization_params)
    authorization_str =  sorted_params.keys.inject("OAuth") do |result, key|
      encoded_key = ERB::Util.url_encode(key.to_s)
      encoded_value = ERB::Util.url_encode(authorization_params[key])
      if result == "OAuth"
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
end
