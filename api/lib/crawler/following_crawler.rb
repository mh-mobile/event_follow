# frozen_string_literal: true

class FollowingCrawler < DaemonSpawn::Base
  def start(args)

    loop do
      scope = User.joins(:user_token)
      target_user = scope.where(following_last_updated_at: nil)
                          .or(scope.where.not(following_last_updated_at: Time.current.ago(1.minute)..))
                          .order(Arel.sql('following_last_updated_at asc NULLS FIRST')).limit(1).first
      next unless target_user

      oauth_token = target_user.user_token.access_token
      oauth_token_secret = target_user.user_token.access_token_secret
      twitter_request = TwitterRequest.create(oauth_token: oauth_token, oauth_token_secret: oauth_token_secret)
    
      cursor = target_user.following_next_cursor
      response = twitter_request.following(cursor: cursor)
      users = response.users
      next_cursor = response.next_cursor
      puts "users: #{response}"
      puts "next_cursor: #{next_cursor}"
      puts "users count: #{users.count}"
      next_cursor = response.next_cursor
      cursor = next_cursor == 0 ? -1 : next_cursor
      target_user.update(following_last_updated_at: Time.current, following_next_cursor: cursor)

      next if users.count == 0

      time = Time.current
      inserted_users = users.map do |user|
        {
          id: user.id,
          name: user.name,
          screen_name: user.screen_name,
          profile_image: user.profile_image_url_https,
          created_at: time,
          updated_at: time
        }
      end
      User.insert_all(inserted_users)

      inserted_friendships = users.map do |user|
        {
          follower_id: target_user.id,
          followed_id: user.id,
          created_at: time,
          updated_at: time
        }
      end
      Friendship.insert_all(inserted_friendships)
    ensure
      sleep 5 
    end
  end

  def stop
    puts "stop  : #{Time.now}"
  end
end

FollowingCrawler.spawn!({
  working_dir: Rails.root,
  pid_file: "#{Rails.root}/tmp/following_crawler.pid",
  log_file: "#{Rails.root}/tmp/following_crawler.log",
  sync_log: true,
  singleton: true
})
