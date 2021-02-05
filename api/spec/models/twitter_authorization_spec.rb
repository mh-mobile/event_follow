# frozen_string_literal: true

require "rails_helper"

RSpec.describe TwitterAuthorization, type: :model do
  class TwitterAuthorizationMock < TwitterClient
  end

  let!(:authorization_mock) do
    # sub oauth parameter
    stub_oauth_timestamp = "1612516145"
    stub_oauth_nonce = "HhHK6a6f9P1EjLgrjjXzs939e6S9YHce1JDADnjuMm8"

    # Twitter Authorization mock
    mock = TwitterAuthorizationMock.new(
      app_token: "AAAAAAAAAAAAAAAAATAAAOE0IQEAAAAAL7ucz76iOrcb7g%2FJBASxqIPr4gmU%3D79960AyVu5pDTcZC1fGt57CBkBRkTEqezZ5CMNxDgYWis1FOOBbar",
      oauth_consumer_key: "LLflFIIbQQkfUjM4B304hFoobar",
      oauth_token: "Z6eEdO8MOmk394WozF5oKyuAv855l4Mlqo7hhFoobar",
      oauth_consumer_secret: "cqClvFY7PW2q2sDTZeDJhSftNIMWtO3rtiZQv0A3w3FooBar",
      oauth_token_secret: "AABdcrekDARFDFREFooBar"
    )
    allow(mock).to receive(:oauth_timestamp).and_return(stub_oauth_timestamp)
    allow(mock).to receive(:oauth_nonce).and_return(stub_oauth_nonce)
    mock
  end

  context "twitter config" do
    it "initialize" do
      expect(TwitterAuthorization::API_ENDOPOINT).to eq "https://api.twitter.com/1.1/"
      expect(TwitterAuthorization::SEARCH_COUNT).to eq 100
      expect(TwitterAuthorization::FRIENDS_LIST_COUNT).to eq 200
      expect(TwitterAuthorization::RETWEETS_COUNT).to eq 100
    end
  end

  context "twitter authorization for following" do
    it "app auth token header" do
      app_auth_token_header = authorization_mock.app_auth_token_header
      authorization_header = app_auth_token_header[:Authorization]
      expect(authorization_header).to eq "Bearer AAAAAAAAAAAAAAAAATAAAOE0IQEAAAAAL7ucz76iOrcb7g%2FJBASxqIPr4gmU%3D79960AyVu5pDTcZC1fGt57CBkBRkTEqezZ5CMNxDgYWis1FOOBbar"
    end

    it "following user auth token header" do
      api_path = "friends/list.json"
      query_params = {
        count: 100,
        cursor: -1
      }

      user_auth_token_header = authorization_mock.user_auth_token_header(api_path, query_params)
      authorization_header = user_auth_token_header[:Authorization]
      expect(authorization_header).to eq "OAuth oauth_consumer_key=\"LLflFIIbQQkfUjM4B304hFoobar\", oauth_nonce=\"HhHK6a6f9P1EjLgrjjXzs939e6S9YHce1JDADnjuMm8\", oauth_signature=\"6HUDMyXzssy3Q%2FtouKJetBiNhU8%3D\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1612516145\", oauth_token=\"Z6eEdO8MOmk394WozF5oKyuAv855l4Mlqo7hhFoobar\", oauth_version=\"1.0\""
    end

    it "verify_credentials user auth token header" do
      api_path = "account/verify_credentials.json"
      query_params = {}
      user_auth_token_header = authorization_mock.user_auth_token_header(api_path, query_params)
      authorization_header = user_auth_token_header[:Authorization]
      expect(authorization_header).to eq "OAuth oauth_consumer_key=\"LLflFIIbQQkfUjM4B304hFoobar\", oauth_nonce=\"HhHK6a6f9P1EjLgrjjXzs939e6S9YHce1JDADnjuMm8\", oauth_signature=\"YsD7i06OKOwj%2Fy2oJoe87HI4ecE%3D\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1612516145\", oauth_token=\"Z6eEdO8MOmk394WozF5oKyuAv855l4Mlqo7hhFoobar\", oauth_version=\"1.0\""
    end
  end
end
