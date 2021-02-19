require 'rails_helper'

RSpec.describe "Events", type: :request do

  describe "GET /events" do
    before do
      @hoge_user = User.create!(id: "123456789", name: "hoge", screen_name: "hoge", uid: "theUserID", profile_image: "https://example.com/my_photo.png")
      @hoge_user.user_event_setting = UserEventSetting.find_or_create_by(user_id: @hoge_user.id) 
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
  end

end
