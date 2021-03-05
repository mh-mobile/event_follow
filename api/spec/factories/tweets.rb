# frozen_string_literal: true

FactoryBot.define do
  factory :tweet_template, class: Tweet do
    sequence(:id) { |n| "#{n}" }
    sequence(:text) { |n| "ツイート内容: #{n}" }
    tweeted_at { Time.current }

    trait :tweet_three_hours_ago do
      text { |n| "tweet at tweet_treee_hours_ago" }
      tweeted_at { Time.current.ago(3.hours) }
    end

    trait :tweet_four_hours_ago do
      text { |n| "tweet at tweet_four_hours_ago" }
      tweeted_at { Time.current.ago(4.hours) }
    end

    trait :tweet_twenty_three_hours_ago do
      text { |n| "tweet at tweet_twenty_three_hours_ago" }
      tweeted_at { Time.current.ago(23.hour) }
    end

    trait :tweet_twenty_five_hours_ago do
      text { |n| "tweet at tweet_twenty_five_hours_ago" }
      tweeted_at { Time.current.ago(25.hours) }
    end

    trait :tweet_last_udpate_two_days_ago do
      text { |n| "update at two_days_ago" }
      tweeted_at { Time.current.ago(10.hours) }
      retweet_last_updated_at { Time.current.ago(2.days) }
    end

    trait :tweet_last_udpate_three_days_ago do
      text { |n| "update at three_days_ago" }
      tweeted_at { Time.current.ago(10.hours) }
      retweet_last_updated_at { Time.current.ago(3.days) }
    end
  end
end
