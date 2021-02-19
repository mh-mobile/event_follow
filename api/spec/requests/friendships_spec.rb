require 'rails_helper'

RSpec.describe "Friendships", type: :request do

  describe "GET /friendships" do
    before do
      User.create!(id: "123456789", name: "hoge", screen_name: "hoge", uid: "theUserID", profile_image: "https://example.com/my_photo.png")
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

      get "/api/friendships", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "request with corrent authorization" do
      stub_firebase_id_token

      authenticate
      get "/api/friendships", headers: @headers
      expect(response).to have_http_status(200)
    end

    it "request with invalid authorization" do
      stub_firebase_id_token

      authenticate token: "invalid_token"
      get "/api/friendships", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "validate no request parameters" do
      stub_firebase_id_token

      authenticate
      get "/api/friendships", headers: @headers
      expect {
        assert_request_schema_confirm
      }.to raise_error(Committee::InvalidRequest)
      expect(response).to have_http_status(200)
    end

    it "validate request parameters" do
      stub_firebase_id_token

      authenticate
      get "/api/friendships", params: { user_ids: "1111,2222" }, headers: @headers
      assert_request_schema_confirm
      expect(response).to have_http_status(200)
    end
  end
end
