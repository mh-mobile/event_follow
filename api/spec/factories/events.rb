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
  end
end
