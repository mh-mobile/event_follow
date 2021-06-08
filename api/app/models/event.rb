# frozen_string_literal: true

class Event < ActiveRecord::Base
  extend EventSortFilterable

  belongs_to :site
  has_many :tweets, -> { order(tweeted_at: :desc) }, dependent: :delete_all
  paginates_per 10

  scope :following_events, -> (user) {
     user_event_setting = user.user_event_setting
     scope = joins(:tweets)
      .merge(Tweet.following_tweets(user))
      .group("id")
      .select("events.*")
     if user_event_setting.event_sort_type == "friends_number_order"
       scope = scope.having(Event.time_filter_condition(user_event_setting.time_filter_type))
     else
       scope = scope.having(Event.friends_filter_condition(user_event_setting.friends_filter_type))
     end
     scope.order(Arel.sql(Event.event_sort_condition(user_event_setting.event_sort_type)))
   }

  validates :site_id, presence: true
  validates :site_event_id, presence: true
  validates :title, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :url, presence: true

  def self.convert_events(events, following)
    events.map(&converter(following))
  end

  def self.converter(following)
    Proc.new do |event|
      friend_user_ids = event.tweets.pluck(:user_id).uniq.select do |user_id|
        following.include?(user_id)
      end
      {
        event: event,
        extra: {
          user_ids: friend_user_ids.join(","),
          friends_number: friend_user_ids.length
        }
      }
    end
  end
end
