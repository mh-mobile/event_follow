# frozen_string_literal: true

class User < ApplicationRecord
  has_one :user_token

  def self.find_or_create_from_auth(auth)
    uid = auth.uid
    screen_name = auth.extra.raw_info.screen_name
    name = auth.extra.raw_info.name
    profile_image = auth.extra.raw_info.profile_image_url_https
    user = self.find_or_initialize_by(id: uid)
    user_token = UserToken.find_or_initialize_by(id: user.id)
    user_token.access_token = auth.credentials.token
    user_token.access_token_secret = auth.credentials.secret
    user.user_token = user_token
    user.screen_name = screen_name
    user.name = name
    user.profile_image = profile_image
    user.save
    user
  end
end
