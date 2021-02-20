# frozen_string_literal: true

FactoryBot.define do
  factory :hoge, class: User do
    id { "123456789" }
    name { "hoge" }
    screen_name { "hoge" }
    uid { "theUserID" }
    profile_image { "https://example.com/my_photo.png" }
  end

  factory :taro, class: User do
    id { "8347343" }
    name { "taro" }
    screen_name { "taro" }
    uid { "99999" }
    profile_image { "https://example.com/my_photo.png" }
  end

  factory :hiro, class: User do
    id { "921343" }
    name { "hiro" }
    screen_name { "hoge" }
    uid { "111111" }
    profile_image { "https://example.com/my_photo.png" }
  end
end
