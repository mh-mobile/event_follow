require 'rails_helper'

RSpec.describe "Friendships", type: :request do

  describe "GET /friendships" do
    before do
      @hoge_user = User.create!(id: "123456789", name: "hoge", screen_name: "hoge", uid: "theUserID", profile_image: "https://example.com/my_photo.png")
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

    it "validate response" do
      stub_firebase_id_token

      friend_1 = User.create!(id: "1111", name: "foo", screen_name: "foo", uid: "fooID", profile_image: "https://example.com/my_photo.png")
      friend_2 = User.create!(id: "2222", name: "bar", screen_name: "bar", uid: "barID", profile_image: "https://example.com/my_photo.png")
      @hoge_user.follow!(friend_1)
      @hoge_user.follow!(friend_2)

      authenticate
      get "/api/friendships", params: { user_ids: "1111,2222" }, headers: @headers
      assert_response_schema_confirm

      body = JSON.parse(response.body)
      [friend_1, friend_2].each_with_index do |user, index|
        expect(body[index]["id"]).to eq user.id
      end

      expect(response).to have_http_status(200)
    end
  end
end
