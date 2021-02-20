# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FollowingTweets", type: :request do
  describe "GET /api/following_tweets" do
    before do
      @hoge_user = create(:hoge, user_event_setting: build(:default_setting))
      setup_jwt_authentication
    end

    it "request without authorization" do
      stub_firebase_id_token

      get "/api/following_tweets", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "request without authorization" do
      stub_firebase_id_token

      get "/api/following_tweets", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "request with corrent authorization" do
      stub_firebase_id_token

      authenticate
      get "/api/following_tweets", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "request with invalid authorization" do
      stub_firebase_id_token

      authenticate token: "invalid_token"
      get "/api/following_tweets", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "validate request with no params" do
      stub_firebase_id_token

      authenticate
      get "/api/following_tweets", headers: @headers
      expect {
        assert_request_schema_confirm
      }.to raise_error(Committee::InvalidRequest)
      expect(response).to have_http_status(200)
    end

    it "validate request with params" do
      stub_firebase_id_token

      authenticate
      get "/api/following_tweets", params: { event_id: 1 }, headers: @headers
      assert_request_schema_confirm
      expect(response).to have_http_status(200)
    end

    context "validate following tweets response" do
      before do
        site_1 = create(:site_1)
        taro_user = create(:taro)
        hiro_user = create(:hiro)
        create(:default_friendship, follower: @hoge_user, followed: taro_user)
        create(:default_friendship, follower: @hoge_user, followed: hiro_user)

        @event = create(:event_template, site: site_1)
        100.times do |i|
          if i < 5
            create(:tweet_template, user: taro_user, event: @event)
          elsif i >= 45 && i <= 50
            create(:tweet_template, user: taro_user, event: @event)
            create(:tweet_template, user: hiro_user, event: @event)
          elsif i >= 80
            create(:tweet_template, user: hiro_user, event: @event)
          end
        end
      end

      it "validate response" do
        stub_firebase_id_token

        authenticate
        get "/api/following_tweets", params: { event_id: @event.id }, headers: @headers
        body = JSON.parse(response.body)
        assert_response_schema_confirm
        expect(body.count).to eq 37
        expect(response).to have_http_status(200)
      end
    end
  end
end
