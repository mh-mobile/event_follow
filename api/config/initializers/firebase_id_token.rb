# frozen_string_literal: true

FirebaseIdToken.configure do |config|
  config.redis = Proc.new do
    if Rails.env.production?
      Redis.new(host: ENV["REDIS_URL"])
    else
      Redis.new(host: "redis")
    end
  end.call

  config.project_ids = [ENV["FIREBASE_PROJECT_ID"]]
end
