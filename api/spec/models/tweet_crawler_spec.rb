# frozen_string_literal: true

require "rails_helper"

RSpec.describe TweetCrawler, type: :model do
  let!(:tweet_crawl_setting_1) do
    FactoryBot.create(:tweet_crawl_setting_1)
  end

  describe "ツイートのクロール設定の更新" do
    it "デフォルトのクロール設定値が正しい" do
      expect(tweet_crawl_setting_1.max_id).to eq "0"
      expect(tweet_crawl_setting_1.since_id).to eq "0"
      expect(tweet_crawl_setting_1.search_base_max_id).to eq "0"
    end
  end

  describe "ツイート情報の更新" do
    let!(:hoge_user) do
      FactoryBot.build(:hoge)
    end

    let!(:stub_client) do
      stub_connection = Faraday.new do |connection|
        connection.use FaradayMiddleware::FollowRedirects
        connection.request :url_encoded
        connection.response :mashify, mash_class: EventResponse
        connection.response :json
        connection.response :raise_error
        connection.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get("search/tweets.json") do |env|
            [200, {}, read_fixture_json("twitter_search_200.json")]
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

    let(:search_tweets) do
      body = stub_client.search(q: "(url:doorkeeper.jp/events OR url:connpass.com/event/) -filter:retweets filter:links", max_id: "0", since_id: "0")
      body.statuses
    end

    before do
      allow_any_instance_of(TweetCrawlable).to receive(:search_tweets).and_return(search_tweets)
    end

    it "ツイート情報の取得" do
      expect {
        TweetCrawler.new.execute
      }.to change { CrawlTweet.count }.from(0).to(2)
      setting = TweetCrawlSetting.first
      expect(setting.max_id).to eq "0"
      expect(setting.since_id).to eq "1357533943214873217"
      expect(setting.search_base_max_id).to eq "0"
    end

    def read_fixture_json(filename)
      File.open(File.dirname(__FILE__) + "/../fixtures/" + filename, "rb").read
    end
  end
end
