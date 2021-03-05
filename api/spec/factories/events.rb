# frozen_string_literal: true

FactoryBot.define do
  factory :event_template, class: Event do
    sequence(:id) { |n| n }
    sequence(:site_event_id) { |n| n }
    sequence(:description) { |n| "概要_#{n}" }
    sequence(:title) { |n| "event_#{n}" }
    sequence(:url) { |n| "https://example.com/events/#{n}" }
    banner { "https://example.com/my_photo.png" }
    started_at { "2050-02-26T19:00:00+09:00" }
    ended_at { "2070-03-15T19:00:00+09:00"  }

    trait :event_day_03_02 do
      started_at { "2021-03-02T19:00:00+09:00" }
      ended_at { "2021-03-02T21:00:00+09:00" }
    end

    trait :event_day_03_03 do
      started_at { "2021-03-03T19:00:00+09:00" }
      ended_at { "2021-03-03T21:00:00+09:00" }
    end

    trait :event_day_03_05 do
      started_at { "2021-03-05T19:00:00+09:00" }
      ended_at { "2021-03-05T21:00:00+09:00" }
    end

    trait :event_day_03_06 do
      started_at { "2021-03-06T19:00:00+09:00" }
      ended_at { "2021-03-06T21:00:00+09:00" }
    end
  end
end
