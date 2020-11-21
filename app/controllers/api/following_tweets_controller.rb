class Api::FollowingTweetsController < Api::BaseController
  def index
    @tweets = Tweet.following_tweets(current_user).preload(:user)
  end
end
