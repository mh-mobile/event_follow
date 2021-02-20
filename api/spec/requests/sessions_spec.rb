# frozen_string_literal: true

require "rails_helper"

class DummyUser < Struct.new(:name, :screen_name, :profile_image_url_https, :id_str)
end

RSpec.describe "Sessions", type: :request do
  describe "POST /api/sessions" do
    before do
      setup_jwt_authentication
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

      post "/api/sessions",
        params: { token: @token, access_token: dummy_access_token, access_token_secret: dummy_access_token_secret },
        headers: headers, as: :json
      body = JSON.parse(response.body)
      assert_request_schema_confirm
      assert_response_schema_confirm
      expect(body["status"]).to eq "OK"

      login_user = User.first
      dummy_user = verify_credentials
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
end
