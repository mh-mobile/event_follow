# frozen_string_literal: true

module BaseCrawlable
  extend ActiveSupport::Concern

  def tweet_users(users)
    time = Time.current
    users.map do |user|
      {
        id: user.id_str,
        name: user.name,
        screen_name: user.screen_name,
        profile_image: user.profile_image_url_https,
        created_at: time,
        updated_at: time
      }
    end
  end
end
