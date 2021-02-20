require 'rails_helper'

RSpec.describe "Events", type: :request do

  describe "GET /events" do
    before do
      @hoge_user = create(:hoge, user_event_setting: build(:default_setting))
      jwt = JSON.parse(File.read(file_fixture('jwt.json')))
      @token = jwt['jwt_token']
      @certificate = JSON.parse(File.read(file_fixture('certificates.json')))
      @project_ids = ["firebase-id-token"]
    end

    def authenticate token: @token
      @headers ||= {}
      @headers["Authorization"] = "Bearer #{token}"
      @headers
    end

    def stub_firebase_id_token
      allow_any_instance_of(FirebaseIdToken::Certificates).to receive(:local_certs).and_return(@certificate)
      allow_any_instance_of(FirebaseIdToken::Configuration).to receive(:project_ids).and_return(@project_ids)
    end

    it "request without authorization" do
      stub_firebase_id_token

      get "/api/events", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "request without authorization" do
      stub_firebase_id_token

      get "/api/events", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "request with corrent authorization" do
      stub_firebase_id_token

      authenticate
      get "/api/events", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "request with invalid authorization" do
      stub_firebase_id_token

      authenticate token: "invalid_token"
      get "/api/events", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "validate no event response" do
      stub_firebase_id_token

      authenticate
      get "/api/events", headers: @headers
      assert_response_schema_confirm
      body = JSON.parse(response.body)
      expect(body["meta"]["total_count"]).to eq 0
      expect(body["data"].count).to eq 0
      expect(response).to have_http_status(200)
    end

    context "validate event response" do
      before do
        site_1 = create(:site_1)
        taro_user = create(:taro)
        hiro_user = create(:hiro)
        create(:default_friendship, follower: @hoge_user, followed: taro_user)
        create(:default_friendship, follower: @hoge_user, followed: hiro_user)
  
        100.times do |i|
          event = create(:event_template, site: site_1)
          if i < 5
            create(:tweet_template, user: taro_user, event: event)
          elsif i >= 45 && i <= 50
            create(:tweet_template, user: taro_user, event: event)
            create(:tweet_template, user: hiro_user, event: event)
          elsif i >= 80
            create(:tweet_template, user: hiro_user, event: event)
          end
        end
      end

      it "validate response with no params" do
        stub_firebase_id_token
  
        authenticate
        get "/api/events", headers: @headers
        body = JSON.parse(response.body)
        assert_response_schema_confirm
        expect(body["meta"]["total_count"]).to eq 31
        expect(body["meta"]["current_page"]).to eq 1
        expect(body["meta"]["event_sort_type"]).to eq "friends_number_order"
        expect(body["meta"]["time_filter_type"]).to eq "past_24_hours"
        expect(body["data"].count).to eq 10
        expect(response).to have_http_status(200)
      end

      it "validate response with params page: 2, sort: \"recent_order\", friends: \"one_or_more_friends\", time: \"past_24_hours\"" do
        stub_firebase_id_token
  
        authenticate
        get "/api/events", params: { page: 2, sort: "recent_order", friends: "one_or_more_friends", time: "past_24_hours" }, headers: @headers
        body = JSON.parse(response.body)
        assert_response_schema_confirm
        expect(body["meta"]["total_count"]).to eq 31
        expect(body["meta"]["current_page"]).to eq 2
        expect(body["meta"]["event_sort_type"]).to eq "recent_order"
        expect(body["meta"]["friends_filter_type"]).to eq "one_or_more_friends"
        expect(body["data"].count).to eq 10
        expect(response).to have_http_status(200)
      end

      it "validate response with params page: 1, sort: \"created_order\", friends: \"two_or_more_friends\", time: \"past_24_hours\"" do
        stub_firebase_id_token
  
        authenticate
        get "/api/events", params: { page: 1, sort: "created_order", friends: "two_or_more_friends", time: "past_24_hours" }, headers: @headers
        body = JSON.parse(response.body)
        assert_response_schema_confirm
        expect(body["meta"]["total_count"]).to eq 6
        expect(body["meta"]["current_page"]).to eq 1
        expect(body["meta"]["event_sort_type"]).to eq "created_order"
        expect(body["meta"]["friends_filter_type"]).to eq "two_or_more_friends"
        expect(body["data"].count).to eq 6
        expect(response).to have_http_status(200)
      end
    end
  end

end
