# frozen_string_literal: true

class FollowingCrawler
  include BaseCrawlable
  include FollowingCrawlable

  def start
    target_user = find_target_user
    return unless target_user

    users, next_cursor = search_following(target_user)
    update_target_user_state(target_user, next_cursor)
    return if users.empty?

    update_tweet_users(users)
    update_friendships(target_user, users)
  end
end
