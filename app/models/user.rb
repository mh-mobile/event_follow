# frozen_string_literal: true

class User < ApplicationRecord
  has_one :user_token
  has_one :user_event_setting
  has_many :friendships, foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :friendships, source: :followed

  def follow!(user)
    following << user
  end

  def unfollow!(user)
    friendships.find_by!(followed_id: user.id).destroy!
  end

  def following?(user)
    following.include?(user)
  end

  def following_tweets(event)
    user_ids = following_user_ids
    event.tweets.select do |tweet|
      user_ids.include?(tweet.user_id)
    end
  end

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
    user.user_event_setting = UserEventSetting.find_or_create_by(user_id: user.id) unless user.user_event_setting.present?
    user.screen_name = screen_name
    user.name = name
    user.profile_image = profile_image
    user.save
    user
  end

  private
    def following_user_ids
      following.ids
    end
end
