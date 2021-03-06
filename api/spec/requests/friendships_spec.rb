# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Friendships", type: :request do
  describe "GET /friendships" do
    before do
      @hoge_user = create(:hoge)
      setup_jwt_authentication
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

      friend_1 = create(:hiro)
      friend_2 = create(:taro)
      @hoge_user.follow!(friend_1)
      @hoge_user.follow!(friend_2)

      authenticate
      get "/api/friendships", params: { user_ids: "#{friend_1.id},#{friend_2.id}" }, headers: @headers
      assert_response_schema_confirm

      body = JSON.parse(response.body)
      [friend_1, friend_2].each_with_index do |user, index|
        expect(body[index]["id"]).to eq user.id
      end

      expect(response).to have_http_status(200)
    end
  end
end
