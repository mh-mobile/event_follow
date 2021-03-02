# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventCrawler, type: :model do
  let!(:site_1) do
    FactoryBot.create(:site_1)
  end

  describe "ツイート情報の取得" do
    let!(:hoge_user) do
      FactoryBot.create(:hoge)
    end

    let(:test_tweet) do
      FactoryBot.create(:crawl_tweet_template, user: hoge_user)
    end

    context "ツイート情報がない場合" do
      it "ツイートを取得できない" do
        expect(CrawlTweet.count).to eq 0
      end
    end

    context "ツイート情報がある場合" do
      it "ツイートを取得できる" do
        test_tweet
        expect(CrawlTweet.count).to eq 1
      end
    end
  end

  describe "不正なイベントURLを含むツイート情報からイベント情報を取得" do
    let!(:hoge_user) do
      FactoryBot.create(:hoge)
    end

    let(:test_tweet) do
      FactoryBot.create(:crawl_tweet_template, user: hoge_user)
    end

    let(:event_day_03_06) do
      FactoryBot.build(:event_template, :event_day_03_06, url: "https://example.com/event/12345/", site: site_1)
    end

    before do
      allow_any_instance_of(ConnpassRequest).to receive(:request).and_return(event_day_03_06)
    end

    it "イベント情報が取得される" do
      event_day_03_06
      travel_to("2021-03-04 23:00".to_time)
      expect { EventCrawler.new.execute }.not_to change { Event.count }
    end
  end

  describe "connpassのイベントURLを含むツイート情報からイベント情報を取得" do
    let!(:hoge_user) do
      FactoryBot.create(:hoge)
    end

    let(:test_tweet) do
      FactoryBot.create(:crawl_tweet_template, user: hoge_user)
    end

    let(:event_day_03_06) do
      FactoryBot.build(:event_template, :event_day_03_06, url: test_tweet.event_url, site: site_1)
    end

    before do
      allow_any_instance_of(ConnpassRequest).to receive(:request).and_return(event_day_03_06)
    end

    context("イベントが終了していない場合") do
      it "イベント情報が保存される" do
        event_day_03_06
        travel_to("2021-03-04 23:00".to_time)
        expect { EventCrawler.new.execute }.to change { [Event.count, CrawlTweet.count, Tweet.count] }.from([0, 1, 0]).to([1, 0, 1])
      end
    end

    context("イベントが終了している場合") do
      it "イベント情報が保存されない" do
        event_day_03_06
        travel_to("2021-03-20 23:00".to_time)
        expect { EventCrawler.new.execute }.to change { [Event.count, CrawlTweet.count, Tweet.count] }.from([0, 1, 0]).to([0, 0, 0])
      end
    end
  end
end
