require 'rails_helper'

RSpec.describe "FollowingTweets", type: :request do
  describe "GET /api/following_tweets" do

    before do
      @hoge_user = create(:hoge, user_event_setting: build(:default_setting))
      jwt = JSON.parse(File.read(file_fixture("jwt.json")))
      @token = jwt["jwt_token"]
      @certificate = JSON.parse(File.read(file_fixture("certificates.json")))
      @project_ids = ["firebase-id-token"]
    end

    def authenticate(token: @token)
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

  end
end
