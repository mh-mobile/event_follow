# frozen_string_literal: true

FactoryBot.define do
  factory :tomo_user_token, class: UserToken do
    association :user, factory: :tomo
    access_token { "tomo_access_token" }
    access_token_secret { "tomo_access_token_secret" }
  end

  factory :satoshi_user_token, class: UserToken do
    association :user, factory: :satoshi
    access_token { "satoshi_access_token" }
    access_token_secret { "satoshi_access_token_secret" }
  end

  factory :jiro_user_token, class: UserToken do
    association :user, factory: :jiro
    access_token { "jiro_access_token" }
    access_token_secret { "jiro_access_token_secret" }
  end

end
