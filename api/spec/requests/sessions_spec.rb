# frozen_string_literal: true

require "rails_helper"

class DummyUser < Struct.new(:name, :screen_name, :profile_image_url_https, :id_str)
end

RSpec.describe "Sessions", type: :request do
  describe "POST /api/sessions" do
    let!(:stub_client) do
      stub_connection = Faraday.new do |connection|
        connection.use FaradayMiddleware::FollowRedirects
        connection.request :url_encoded
        connection.response :mashify, mash_class: EventResponse
        connection.response :json
        connection.response :raise_error
        connection.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get("friends/list.json") do |env|
            [200, {}, read_fixture_json("friends_list_next_cursor_1522334438265527337.json")]
          end
        end
      end

      twitter_client = TwitterClient.new(
        app_token: "test_app_token",
        oauth_consumer_key: "test_oauth_consumer_key",
        oauth_token: "test_oauth_token",
        oauth_consumer_secret: "test_oauth_consumer_secret",
        oauth_token_secret: "test_oauth_token_secret"
      )
      allow(twitter_client).to receive(:connection).and_return(stub_connection)
      twitter_client
    end

    let(:search_following) do
      response = stub_client.following(count: "0")
      [response.users, response.next_cursor_str]
    end

    before do
      setup_jwt_authentication
      stub_following_crawler
    end

    def verify_credentials
      DummyUser.new("test_screen_name", "test_name", "https://example.com/my_photo.png", "987654321")
    end

    def headers
      @headers ||= {}
      @headers["Content-Type"] = "application/json"
      @headers
    end

    it "validate no request params" do
      stub_firebase_id_token

      post "/api/sessions"
      body = JSON.parse(response.body)
      expect {
        assert_request_schema_confirm
      }.to raise_error(Committee::InvalidRequest)
      expect(body["status"]).to eq "NG"
      expect(body["error_message"]).to eq "認証情報が不正です"
      expect(response).to have_http_status(200)
    end

    it "validate authorized request params" do
      stub_firebase_id_token
      stub_twitter_request

      dummy_access_token = "dummy_access_token"
      dummy_access_token_secret =  "dummy_access_token_secret"

      expect {
        post "/api/sessions",
          params: { token: @token, access_token: dummy_access_token, access_token_secret: dummy_access_token_secret },
          headers: headers, as: :json
      }.to change { Friendship.count }.from(0).to(3)

      body = JSON.parse(response.body)
      assert_request_schema_confirm
      assert_response_schema_confirm
      expect(body["status"]).to eq "OK"

      dummy_user = verify_credentials
      login_user = User.find(dummy_user.id_str)
      expect(login_user.name).to eq dummy_user.name
      expect(login_user.screen_name).to eq dummy_user.screen_name
      expect(login_user.profile_image).to eq dummy_user.profile_image_url_https
      expect(login_user.id).to eq dummy_user.id_str
      expect(login_user.uid).to eq "theUserID"
      expect(login_user.user_token.access_token).to eq dummy_access_token
      expect(login_user.user_token.access_token_secret).to eq dummy_access_token_secret
      expect(response).to have_http_status(200)
    end
  end

  def stub_following_crawler
    allow_any_instance_of(FollowingCrawler).to receive(:search_following).and_return(search_following)
  end
end
