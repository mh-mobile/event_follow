# frozen_string_literal: true

module EventSortFilterable
  def event_sort_condition(type)
    case type
    when "friends_number_order"
      "count(distinct tweets.user_id) DESC"
    when "recent_order"
      "MIN(tweets.tweeted_at) DESC"
    when "created_order"
      "MIN(tweets.tweeted_at) ASC"
    when "closeness_order"
      "started_at DESC"
    else
      "count(distinct tweets.user_id) DESC"
    end
  end

  def time_filter_condition(type)
    past_time = 1.day
    case type
    when "past_8_hours"
      past_time = 8.hours
    when "past_24_hours"
      past_time = 24.hours
    when "past_2_days"
      past_time = 2.days
    when "past_3_days"
      past_time = 3.days
    when "past_4_days"
      past_time = 4.days
    when "past_5_days"
      past_time = 5.days
    when "past_6_days"
      past_time = 6.days
    when "past_1_weeks"
      past_time = 7.days
    when "past_all"
      past_time = 365.days
    end

    "MIN(tweets.tweeted_at) >= '#{Time.current.ago(past_time)}'"
  end

  def friends_filter_condition(type)
    friends_number = 1
    case type
    when "one_or_more_friends"
      friends_number =  1
    when "two_or_more_friends"
      friends_number =  2
    when "three_or_more_friends"
      friends_number =  3
    when "four_or_more_friends"
      friends_number =  4
      kwhen "five_or_more_friends"
      friends_number =  5
    end

    "count(distinct tweets.user_id) >= #{friends_number}"
  end
end
