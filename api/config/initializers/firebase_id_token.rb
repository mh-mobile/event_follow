FirebaseIdToken.configure do |config|
  config.redis = Redis.new
  config.project_ids = ["firebase_project_id"]
end
