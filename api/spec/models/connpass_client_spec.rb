# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConnpassClient, type: :model do
  let!(:stub_client) do
    stub_connection = Faraday.new do |connection|
      connection.use FaradayMiddleware::FollowRedirects
      connection.request :url_encoded
      connection.response :mashify, mash_class: EventResponse
      connection.response :json
      connection.response :raise_error
      connection.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("event/?event_id=200") do |env|
          [200, {}, read_fixture_json("connpass_search_200.json")]
        end

        stub.get("event/?event_id=404") do |env|
          [404, {}, {}.to_json]
        end

        stub.get("event/?event_id=503") do |env|
          [503, {}, {}.to_json]
        end
      end
    end

    connpass_client = ConnpassClient.new
    allow(connpass_client).to receive(:connection).and_return(stub_connection)
    connpass_client
  end

  context "connpass config" do
    it "initialize" do
      expect(stub_client.class::API_ENDOPOINT).to eq "https://connpass.com/api/v1"
    end
  end

  context "connpass search" do
    it "200" do
      body = stub_client.search("200")
      events = body.events
      expect(events.count).to eq 1

      event = events.first
      expect(event.event_id).to eq 200
      expect(event.title).to eq "【オンライン開催】イベントです"
      expect(event.description).to eq "Ruby on Railsのコミュティティ"
      expect(event.started_at).to eq "2021-02-26T19:00:00+09:00"
      expect(event.ended_at).to eq "2021-02-26T21:00:00+09:00"
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

  def read_fixture_json(filename)
    File.open(File.dirname(__FILE__) + "/../fixtures/" + filename, "rb").read
  end
end
