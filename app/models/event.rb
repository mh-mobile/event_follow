# frozen_string_literal: true

class Event < ActiveRecord::Base
  extend EventSortFilterable

  belongs_to :site
  has_many :tweets, -> { order(tweeted_at: :desc) }, dependent: :delete_all

  scope :following_events, -> (user, event_sort_type, event_filter_type) {
    scope = joins(:tweets)
    .merge(Tweet.following_tweets(user))
    .group("id")
    .select("events.*")
    if event_sort_type == "friends_number_order"
      scope = scope.having(Event.time_filter_condition(event_filter_type))
    else
      scope = scope.having(Event.friends_filter_condition(event_filter_type))
    end
    scope.order(Arel.sql(Event.event_sort_condition(event_sort_type)))
    .preload(tweets: :restricted_user)
  }

  validates :site_id, presence: true
  validates :site_event_id, presence: true
  validates :title, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :url, presence: true
end
