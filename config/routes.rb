# frozen_string_literal: true

Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#create"
  delete "logout", to: "sessions#destory"

  constraints -> request { request.session[:user_id].present? } do
    root to: "events#index", as: :authenticated_root
  end

  root to: "homes#show", as: :unauthenticated_root
end
