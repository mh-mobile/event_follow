# frozen_string_literal: true

require "rails_helper"

RSpec.describe TweetCrawler, type: :model do
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
          if q == "1"
            [200, {}, read_fixture_json("twitter_search_100_count_results.json")]
          elsif q == "2"
            [200, {}, read_fixture_json("twitter_search_5_count_results.json")]
          elsif q == "3"
            [200, {}, read_fixture_json("twitter_search_100_count_results.json")]
          elsif q == "4"
            [200, {}, read_fixture_json("twitter_search_5_count_results.json")]
          end
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

  describe "ツイートのクロール設定の更新" do
    let!(:tweet_crawl_setting_1) do
      FactoryBot.create(:tweet_crawl_setting_1)
    end

    it "デフォルトのクロール設定値が正しい" do
      expect(tweet_crawl_setting_1.max_id).to eq "0"
      expect(tweet_crawl_setting_1.since_id).to eq "0"
      expect(tweet_crawl_setting_1.search_base_max_id).to eq "0"
    end
  end

  describe "ツイート情報の更新(max=0、since_id=0、search_base_max_id=205, 100件Max取得)" do
    let!(:tweet_crawl_setting_1) do
      FactoryBot.create(:tweet_crawl_setting_1)
    end

    let!(:hoge_user) do
      FactoryBot.build(:hoge)
    end

    let(:search_tweets) do
      body = stub_client.search(q: "1", max_id: "0", since_id: "0")
      body.statuses
    end

    before do
      allow_any_instance_of(TweetCrawlable).to receive(:search_tweets).and_return(search_tweets)
    end

    it "ツイート情報の取得" do
      expect {
        TweetCrawler.new.execute
      }.to change { CrawlTweet.count }.from(0).to(100)
      setting = TweetCrawlSetting.first
      expect(setting.max_id).to eq "2"
      expect(setting.since_id).to eq "0"
      expect(setting.search_base_max_id).to eq "102"
      expect(User.count).to eq 100
    end
  end

  describe "ツイート情報の更新(max=0、since_id=0、search_base_max_id=205, 5件取得)" do
    let!(:tweet_crawl_setting_1) do
      FactoryBot.create(:tweet_crawl_setting_1)
    end

    let!(:hoge_user) do
      FactoryBot.build(:hoge)
    end

    let(:search_tweets) do
      body = stub_client.search(q: "2", max_id: "0", since_id: "0")
      body.statuses
    end

    before do
      allow_any_instance_of(TweetCrawlable).to receive(:search_tweets).and_return(search_tweets)
    end

    it "ツイート情報の取得" do
      expect {
        TweetCrawler.new.execute
      }.to change { CrawlTweet.count }.from(0).to(5)
      setting = TweetCrawlSetting.first
      expect(setting.max_id).to eq "0"
      expect(setting.since_id).to eq "102"
      expect(setting.search_base_max_id).to eq "0"
      expect(User.count).to eq 5
    end
  end

  describe "ツイート情報の更新(max=110、since_id=1、search_base_max_id=205, 100件Max取得)" do
    let!(:tweet_crawl_setting) do
      FactoryBot.create(:tweet_crawl_setting_1, :max_id_105_and_since_id_1_pattern)
    end

    let!(:hoge_user) do
      FactoryBot.build(:hoge)
    end

    let(:search_tweets) do
      body = stub_client.search(q: "3", max_id: "105", since_id: "1")
      body.statuses
    end

    before do
      allow_any_instance_of(TweetCrawlable).to receive(:search_tweets).and_return(search_tweets)
    end

    it "ツイート情報の取得" do
      expect {
        TweetCrawler.new.execute
      }.to change { CrawlTweet.count }.from(0).to(100)
      setting = TweetCrawlSetting.first
      expect(setting.max_id).to eq "2"
      expect(setting.since_id).to eq "1"
      expect(setting.search_base_max_id).to eq "205"
      expect(User.count).to eq 100
    end
  end

  describe "ツイート情報の更新(max=110、since_id=1、search_base_max_id=205, 5件取得)" do
    let!(:tweet_crawl_setting) do
      FactoryBot.create(:tweet_crawl_setting_1, :max_id_105_and_since_id_1_pattern)
    end

    let!(:user_id_100) do
      FactoryBot.create(:user_id_100)
    end

    let(:search_tweets) do
      body = stub_client.search(q: "4", max_id: "105", since_id: "1")
      body.statuses
    end

    before do
      allow_any_instance_of(TweetCrawlable).to receive(:search_tweets).and_return(search_tweets)
    end

    it "ツイート情報の取得" do
      expect {
        TweetCrawler.new.execute
      }.to change { CrawlTweet.count }.from(0).to(5)
      setting = TweetCrawlSetting.first
      expect(setting.max_id).to eq "0"
      expect(setting.since_id).to eq "205"
      expect(setting.search_base_max_id).to eq "0"
      expect(User.count).to eq 5
    end

    it "ユーザー情報の上書き更新" do
      expect {
        TweetCrawler.new.execute
      }.to change { CrawlTweet.count }.from(0).to(5)
      user_id_100.reload
      expect(user_id_100.name).to eq "name_100"
      expect(user_id_100.screen_name).to eq "screen_name_100"
      expect(user_id_100.profile_image).to eq "https://example.com/normal.jpg"
    end
  end

  def read_fixture_json(filename)
    File.open(File.dirname(__FILE__) + "/../fixtures/" + filename, "rb").read
  end
end
