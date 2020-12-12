# frozen_string_literal: true

Rails.application.routes.draw do
  namespace "api", defaults: { format: "json" } do
    resources :following_tweets, only: %i(index)
    resources :friendships, only: %i(index)
  end
end
