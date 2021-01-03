# frozen_string_literal: true

module FollowingCrawlable
  extend ActiveSupport::Concern

  def find_target_user
    scope = User.joins(:user_token)
    scope.where(following_last_updated_at: nil)
         .or(scope.where.not(following_last_updated_at: Time.current.ago(1.minute)..))
         .order(Arel.sql('following_last_updated_at asc NULLS FIRST')).limit(1).first
  end

  def search_following(target_user)
    oauth_token = target_user.user_token.access_token
    oauth_token_secret = target_user.user_token.access_token_secret
    twitter_request = TwitterRequest.create(oauth_token: oauth_token, oauth_token_secret: oauth_token_secret)

    cursor = target_user.following_next_cursor
    response = twitter_request.following(cursor: cursor)
    [response.users, response.next_cursor]
  end

  def update_target_user_state(target_user, next_cursor)
    cursor = next_cursor == 0 ? -1 : next_cursor
    target_user.update(following_last_updated_at: Time.current, following_next_cursor: cursor)
  end

  def inserted_friendships(target_user, users)
    time = Time.current
    users.map do |user|
      {
        follower_id: target_user.id,
        followed_id: user.id,
        created_at: time,
        updated_at: time
      }
    end
  end

  def update_tweet_users(users)
    User.insert_all(inserted_tweet_users(users))
  end

  def update_friendships(target_user, users)
    Friendship.insert_all(inserted_friendships(target_user, users))
  end
end
