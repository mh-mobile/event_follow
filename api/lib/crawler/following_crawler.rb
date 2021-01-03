# frozen_string_literal: true

class FollowingCrawler
  include BaseCrawlable

  def self.start
      scope = User.joins(:user_token)
      target_user = scope.where(following_last_updated_at: nil)
                          .or(scope.where.not(following_last_updated_at: Time.current.ago(1.minute)..))
                          .order(Arel.sql('following_last_updated_at asc NULLS FIRST')).limit(1).first
      return unless target_user

      oauth_token = target_user.user_token.access_token
      oauth_token_secret = target_user.user_token.access_token_secret
      twitter_request = TwitterRequest.create(oauth_token: oauth_token, oauth_token_secret: oauth_token_secret)
    
      cursor = target_user.following_next_cursor
      response = twitter_request.following(cursor: cursor)
      users = response.users
      next_cursor = response.next_cursor
      cursor = next_cursor == 0 ? -1 : next_cursor
      target_user.update(following_last_updated_at: Time.current, following_next_cursor: cursor)

      return if users.count == 0

      time = Time.current
      User.insert_all(tweet_users(users))

      inserted_friendships = users.map do |user|
        {
          follower_id: target_user.id,
          followed_id: user.id,
          created_at: time,
          updated_at: time
        }
      end
      Friendship.insert_all(inserted_friendships)
  end

end
