# frozen_string_literal: true

require "rails_helper"

RSpec.describe TwitterClient, type: :model do
  let!(:stub_client) do
    stub_connection = Faraday.new do |connection|
      connection.use FaradayMiddleware::FollowRedirects
      connection.request :url_encoded
      connection.response :mashify, mash_class: EventResponse
      connection.response :json
      connection.response :raise_error
      connection.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("search/tweets.json") do |env|
          q = env.params["q"]
          if q == "404"
            [404, {}, {}.to_json]
          elsif q == "503"
            [503, {}, {}.to_json]
          else
            [200, {}, read_fixture_json("twitter_search_200.json")]
          end
        end

        stub.get("statuses/retweets/200.json") do |env|
          [200, {}, read_fixture_json("retweets_200.json")]
        end

        stub.get("statuses/retweets/404.json") do |env|
          [404, {}, {}.to_json]
        end

        stub.get("statuses/retweets/503.json") do |env|
          [503, {}, {}.to_json]
        end

        stub.get("friends/list.json") do |env|
          count = env.params["count"]
          if count == "404"
            [404, {}, {}.to_json]
          elsif count == "503"
            [503, {}, {}.to_json]
          else
            [200, {}, read_fixture_json("friends_list_200.json")]
          end
        end

        stub.get("account/verify_credentials.json") do |env|
          [200, {}, read_fixture_json("verify_credentials_200.json")]
        end
      end
    end

    twitter_client = TwitterClient.new(
      app_token: "test_app_token",
      oauth_consumer_key: "test_oauth_consumer_key",
      oauth_token: "test_oauth_token",
      oauth_consumer_secret: "test_oauth_consumer_secret",
      oauth_token_secret: "test_oauth_token_secret"
    )
    allow(twitter_client).to receive(:connection).and_return(stub_connection)
    twitter_client
  end

  context "twitter config" do
    it "initialize" do
      expect(stub_client.instance_variable_get("@app_token")).to eq "test_app_token"
      expect(stub_client.instance_variable_get("@oauth_consumer_key")).to eq "test_oauth_consumer_key"
      expect(stub_client.instance_variable_get("@oauth_token")).to eq "test_oauth_token"
      expect(stub_client.instance_variable_get("@oauth_consumer_secret")).to eq "test_oauth_consumer_secret"
      expect(stub_client.instance_variable_get("@oauth_token_secret")).to eq "test_oauth_token_secret"
    end
  end

  context "twitter search" do
    it "200" do
      body = stub_client.search(q: "(url:doorkeeper.jp/events OR url:connpass.com/event/) -filter:retweets filter:links", max_id: "0", since_id: "0")
      statuses = body.statuses
      expect(statuses.count).to eq 2
      tweet_1 = statuses[0]
      tweet_2 = statuses[1]
      expect(tweet_1.id_str).to eq "1357533943214873217"
      expect(tweet_1.entities.urls.first.expanded_url).to eq "https://tsj.connpass.com/event/200415/"
      expect(tweet_2.id_str).to eq "1357533943214893217"
      expect(tweet_2.entities.urls.first.expanded_url).to eq "https://readyfor.connpass.com/event/198730/"
    end

    it "404" do
      expect {
        stub_client.search(q: "404")
      }.to raise_error(Faraday::ResourceNotFound)
    end

    it "503" do
      expect {
        stub_client.search(q: "503")
      }.to raise_error(Faraday::ServerError)
    end
  end

  context "retweets search" do
    it "200" do
      body = stub_client.retweets(tweet_id: "200")
      expect(body.count).to eq 2
      retweet_1 = body[0]
      retweet_2 = body[1]
      expect(retweet_1.id_str).to eq "1111"
      expect(retweet_1.retweeted_status.id_str).to eq "3333"
      expect(retweet_1.full_text).to eq "RT 11111"
      expect(retweet_2.id_str).to eq "4444"
      expect(retweet_2.retweeted_status.id_str).to eq "666666"
      expect(retweet_2.full_text).to eq "RT 44444"
    end

    it "404" do
      expect {
        stub_client.retweets(tweet_id: "404")
      }.to raise_error(Faraday::ResourceNotFound)
    end

    it "503" do
      expect {
        stub_client.retweets(tweet_id: "503")
      }.to raise_error(Faraday::ServerError)
    end
  end

  context "twitter following" do
    it "200" do
      body = stub_client.following(count: "200")
      users = body.users
      expect(users.count).to eq 2
      user_1 = users[0]
      user_2 = users[1]
      expect(user_1.id_str).to eq "111111"
      expect(user_1.created_at).to eq "Mon Aug 31 18:35:53 +0000 2009"
      expect(user_2.id_str).to eq "222222"
      expect(user_2.created_at).to eq "Mon Aug 31 16:34:30 +0000 2010"
      expect(body.next_cursor_str).to eq "1522334438265527337"
    end

    it "404" do
      expect {
        stub_client.following(count: "404")
      }.to raise_error(Faraday::ResourceNotFound)
    end

    it "503" do
      expect {
        stub_client.following(count: "503")
      }.to raise_error(Faraday::ServerError)
    end
  end

  context "twitter verify_credentials" do
    it "200" do
      body = stub_client.verify_credentials
      expect(body.id_str).to eq "4701600391"
      expect(body.screen_name).to eq "mh_mobiler"
    end
  end

  def read_fixture_json(filename)
    File.open(File.dirname(__FILE__) + "/../fixtures/" + filename, "rb").read
  end
end
