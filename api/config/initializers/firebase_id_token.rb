# frozen_string_literal: true

FirebaseIdToken.configure do |config|
  config.redis = Redis.new(host: "redis")
  config.project_ids = ["firebase_project_id"]
end
