# frozen_string_literal: true

FactoryBot.define do
    factory :crawl_tweet_template, class: CrawlTweet do
      sequence(:id) { |n| "#{n}" }
      sequence(:text) { |n| "ツイート内容: #{n}" }
      tweeted_at { Time.current }
      event_url { "https://hoge.connpass.com/event/1234567/" }
    end
  end
