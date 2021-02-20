# frozen_string_literal: true

FactoryBot.define do
  factory :site_1, class: Site do
    id { 1 }
    name { "Connpass" }
  end

  factory :site_2, class: Site do
    id { 2 }
    name { "Doorkeeper" }
  end

  factory :site_3, class: Site do
    id { 3 }
    name { "TECH PLAY" }
  end
end
