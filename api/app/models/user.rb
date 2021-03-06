# frozen_string_literal: true

class User < ApplicationRecord
  has_one :user_token, dependent: :destroy
  has_one :user_event_setting, dependent: :destroy
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

  def self.find_or_create_from_auth(payload:, access_token:, access_token_secret:)
    request = TwitterRequest.create(
      oauth_token: access_token,
      oauth_token_secret: access_token_secret)

    auth = request.verify_credentials
    screen_name = auth.screen_name
    name = auth.name
    profile_image = auth.profile_image_url_https
    twitter_id = auth.id_str

    self.find_or_initialize_by(id: twitter_id).tap do |user|
      user.uid = payload["sub"]
      user.user_token = UserToken.find_or_initialize_by(user_id: user.id).tap do |user_token|
        user_token.access_token = access_token
        user_token.access_token_secret = access_token_secret
      end
      user.user_event_setting = UserEventSetting.find_or_create_by(user_id: user.id) unless user.user_event_setting.present?
      user.id = twitter_id
      user.screen_name = screen_name
      user.name = name
      user.profile_image = profile_image
      user.save
    end
  end

  private
    def following_user_ids
      following.ids
    end
end
