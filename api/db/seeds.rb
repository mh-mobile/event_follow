# frozen_string_literal: true

require "active_record/fixtures"
require "factory_bot"

ActiveRecord::FixtureSet.create_fixtures \
  "db/fixtures",
  %i[sites]

FactoryBot.define do
  sequence :event_name do |i|
    "VS Code Conference Japan_#{i}"
  end

  sequence :event_description do |i|
    "VS Code 5周年イベント です！

    Visual Studio Code がリリースされてからもうすぐ 5 周年になるのを記念して、VS Code Meetup 主催のデジタルイベントを開催いたします！！！
    Visual Studio Code に興味がある方、Visual Studio Code を愛している方、我こそはと Visual Studio Code について語りたい方など、みんなで集まって 5 周年をお祝いしよう！！！_#{i}"
  end

  sequence :user_id do |i|
    i
  end

  sequence :tweet_id do |i|
    i
  end


  sequence :tweet_text do |i|
    "ツイート_#{i}"
  end


  sequence :user_screen_name do |i|
    "screen_name_#{i}"
  end

  sequence :user_name do |i|
    "name_#{i}"
  end


  factory :site do
  end

  factory :event do
    site_id { 1 }
    title { generate :event_name }
    description { generate :event_description }
    started_at { "2020-10-28T02:20:44+00:00" }
    ended_at { "2020-10-30T02:20:44+00:00" }
    banner { "https://placeimg.com/320/240/tech" }
    url { "https://connpass.com" }
  end

  factory :user do
    id { generate :user_id }
    screen_name { generate :user_screen_name }
    name { generate :user_name }
    profile_image { "https://twitter.com" }
  end


  factory :tweet do
    id { generate :tweet_id }
    text { generate :tweet_text }
    tweeted_at { "2020-10-30T02:20:44+00:00" }
  end
end
connpass = Site.find(1)
1.upto(1000).each do |i|
  FactoryBot.create(:event, site_id: connpass.id, site_event_id: i)
end

1.upto(200).each do |i|
  FactoryBot.create(:user)
end

1.upto(100).each do |i|
  FactoryBot.create(:tweet, event_id: Event.all[500].id, user_id: User.all[2].id, quoted_tweet_id: nil, retweeted_tweet_id: nil)
end


# User.find(4701600391).follow!(User.all[2])
