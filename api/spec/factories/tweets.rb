# frozen_string_literal: true

FactoryBot.define do
  factory :tweet_template, class: Tweet do
    sequence(:id) { |n| "#{n}" }
    sequence(:text) { |n| "ツイート内容: #{n}" }
    tweeted_at { Time.current }
  end
end
