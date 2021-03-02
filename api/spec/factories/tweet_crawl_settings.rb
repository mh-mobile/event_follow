# frozen_string_literal: true

FactoryBot.define do
  factory :tweet_crawl_setting_1, class: TweetCrawlSetting do
    id { 1 }
    max_id { "0" }
    since_id { "0" }
    search_base_max_id { "0" }
  end
end
