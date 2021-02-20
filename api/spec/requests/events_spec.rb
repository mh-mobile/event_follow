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
  end

end
