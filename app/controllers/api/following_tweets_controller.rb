class Api::FollowingTweetsController < Api::BaseController
  def index
    @tweets = Tweet.tweets_for_event(params[:event_id])
                   .following_tweets(current_user).preload(:user)
                   .order(tweeted_at: :desc)
  end
end
