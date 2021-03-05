# frozen_string_literal: true

require "rails_helper"

RSpec.describe DoorkeeperClient, type: :model do
  let!(:stub_client) do
    stub_connection = Faraday.new do |connection|
      connection.use FaradayMiddleware::FollowRedirects
      connection.request :url_encoded
      connection.response :mashify, mash_class: EventResponse
      connection.response :json
      connection.response :raise_error
      connection.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("events/200") do |env|
          [200, {}, read_fixture_json("doorkeeper_search_200.json")]
        end

        stub.get("events/404") do |env|
          [404, {}, {}.to_json]
        end

        stub.get("events/503") do |env|
          [503, {}, {}.to_json]
        end
      end
    end

    connpass_client = DoorkeeperClient.new("test_token")
    allow(connpass_client).to receive(:connection).and_return(stub_connection)
    connpass_client
  end

  context "doorkeeper config" do
    it "initialize" do
      expect(stub_client.class::API_ENDOPOINT).to eq "https://api.doorkeeper.jp/"
    end
  end

  context "doorkeeper search" do
    it "200" do
      body = stub_client.search("200")
      event = body.event
      expect(event.id).to eq 200
      expect(event.title).to eq "もくもく会Vol.1"
      expect(event.description).to eq "もくもく会です"
      expect(event.starts_at).to eq "2021-02-05T13:00:00.000Z"
      expect(event.ends_at).to eq "2021-02-05T14:00:00.000Z"
    end

    it "404" do
      expect {
        stub_client.search("404")
      }.to raise_error(Faraday::ResourceNotFound)
    end

    it "503" do
      expect {
        stub_client.search("503")
      }.to raise_error(Faraday::ServerError)
    end
  end
end
