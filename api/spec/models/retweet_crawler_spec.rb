# frozen_string_literal: true

require "rails_helper"

RSpec.describe RetweetCrawler, type: :model do
  describe "target_tweet" do
    let(:site_1) do
      FactoryBot.create(:site_1)
    end

    let(:event) do
      FactoryBot.create(:event_template, site: site_1)
    end

    let(:hoge_user) do
      FactoryBot.create(:hoge)
    end

    let(:tweet_three_hours_ago) do
      FactoryBot.create(:tweet_template, :tweet_three_hours_ago, event: event, user: hoge_user)
    end

    let(:tweet_four_hours_ago) do
      FactoryBot.create(:tweet_template, :tweet_four_hours_ago, event: event, user: hoge_user)
    end

    let(:tweet_twenty_three_hours_ago) do
      FactoryBot.create(:tweet_template, :tweet_twenty_three_hours_ago, event: event, user: hoge_user)
    end

    let(:tweet_twenty_five_hours_ago) do
      FactoryBot.create(:tweet_template, :tweet_twenty_five_hours_ago, event: event, user: hoge_user)
    end

    let(:tweet_last_udpate_two_days_ago) do
      FactoryBot.create(:tweet_template, :tweet_last_udpate_two_days_ago, event: event, user: hoge_user)
    end

    let(:tweet_last_udpate_three_days_ago) do
      FactoryBot.create(:tweet_template, :tweet_last_udpate_three_days_ago, event: event, user: hoge_user)
    end

    context "3時間前のツイートがDBに保存されている場合" do
      it "対象のツイートを取得できない" do
        tweet_three_hours_ago
        target_tweet = RetweetCrawler.new.target_tweet
        expect(target_tweet).to eq nil
      end
    end

    context "4時間前のツイートがDBに保存されている場合" do
      it "対象のツイートを取得できる" do
        tweet_four_hours_ago
        target_tweet = RetweetCrawler.new.target_tweet
        expect(target_tweet.text).to eq "tweet at tweet_four_hours_ago"
      end
    end

    context "23時間前のツイートがDBに保存されている場合" do
      it "対象のツイートを取得できる" do
        tweet_twenty_three_hours_ago
        target_tweet = RetweetCrawler.new.target_tweet
        expect(target_tweet.text).to eq "tweet at tweet_twenty_three_hours_ago"
      end
    end

    context "25時間前のツイートがDBに保存されている場合" do
      it "対象のツイートを取得できない" do
        tweet_twenty_five_hours_ago
        target_tweet = RetweetCrawler.new.target_tweet
        expect(target_tweet).to eq nil
      end
    end

    context "最終更新のあるツイートと最終更新のないツイートがある場合" do
      it "最終更新のないツイートの方が優先して取得される" do
        tweet_last_udpate_two_days_ago
        tweet_four_hours_ago
        target_tweet = RetweetCrawler.new.target_tweet
        expect(target_tweet.text).to eq "tweet at tweet_four_hours_ago"
      end
    end

    context "最終更新のあるツイートのみの場合" do
      it "最終更新の古いツイートの方が優先して取得される" do
        tweet_last_udpate_two_days_ago
        tweet_last_udpate_three_days_ago
        target_tweet = RetweetCrawler.new.target_tweet
        expect(target_tweet.text).to eq "update at three_days_ago"
      end
    end
  end

  describe "対象ツイートのリツイート・引用リツイートの取得" do
    let(:site_1) do
      FactoryBot.create(:site_1)
    end

    let(:event) do
      FactoryBot.create(:event_template, site: site_1)
    end

    let(:hoge_user) do
      FactoryBot.create(:hoge)
    end

    let!(:tweet_four_hours_ago) do
      FactoryBot.create(:tweet_template, :tweet_four_hours_ago, event: event, user: hoge_user)
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
            [200, {}, read_fixture_json("quoted_retweet_200.json")]
          end

          stub.get("statuses/retweets/200.json") do |env|
            [200, {}, read_fixture_json("retweets_200.json")]
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

    let(:search_retweets) do
      stub_client.retweets(tweet_id: "200")
    end

    let(:search_quoted_retweets) do
      body = stub_client.search(q: "dummy_target_url")
      body.statuses
    end

    before do
      allow_any_instance_of(RetweetCrawlable).to receive(:search_retweets).and_return(search_retweets)
      allow_any_instance_of(RetweetCrawlable).to receive(:search_quoted_retweets).and_return(search_quoted_retweets)
    end

    it "ユーザーが更新される" do
      expect { RetweetCrawler.new.execute }.to change { User.count }.from(1).to(5)
    end

    it "リツイート・引用リツイートが取得される" do
      expect(tweet_four_hours_ago.reload.retweet_last_updated_at).to eq nil
      expect { RetweetCrawler.new.execute }.to change { Tweet.count }.from(1).to(6)
      expect(tweet_four_hours_ago.reload.retweet_last_updated_at).not_to eq nil

      retweets = Tweet.where.not(retweeted_tweet_id: nil)
      quoted_retweets = Tweet.where.not(quoted_tweet_id: nil)

      aggregate_failures do
        expect(retweets.count).to eq 3
        expect(quoted_retweets.count).to eq 2
        retweets.each do |retweet|
          expect(retweet.event_id).to eq tweet_four_hours_ago.event_id
        end
        quoted_retweets.each do |qutoed_retweet|
          expect(qutoed_retweet.event_id).to eq tweet_four_hours_ago.event_id
        end
        expect(event.tweets.count).to eq 6
      end
    end
  end
end
