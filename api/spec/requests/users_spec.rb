# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    before do
      @hoge_user = create(:hoge)
      setup_jwt_authentication
    end

    it "request without authorization" do
      stub_firebase_id_token

      delete "/api/users", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "request with corrent authorization" do
      stub_firebase_id_token

      authenticate
      delete "/api/users", headers: @headers
      expect(response).to have_http_status(204)
    end

    it "request with invalid authorization" do
      stub_firebase_id_token

      authenticate token: "invalid_token"
      delete "/api/users", headers: @headers
      expect(response).to have_http_status(401)
    end

    it "validate request parameters" do
      stub_firebase_id_token

      authenticate
      delete "/api/users", headers: @headers
      assert_request_schema_confirm
      expect(response).to have_http_status(204)
    end

    it "validate response" do
      stub_firebase_id_token

      authenticate
      delete "/api/users", headers: @headers
      assert_response_schema_confirm

      expect(response).to have_http_status(204)
    end
  end
end
