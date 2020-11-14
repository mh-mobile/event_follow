# frozen_string_literal: true

class UserEventSetting < ActiveRecord::Base
  belongs_to :user

  # ソート種別
  enum event_sort_type: {
    friends_number_order: 0,
    recent_order: 1,
    created_order: 2,
    closeness_order: 3
  }

  # 時間の絞り込み種別
  enum time_filter_type: {
    past_8_hours: 0,
    past_24_hours: 1,
    past_2_days: 2,
    past_3_days: 3,
    past_4_days: 4,
    past_5_days: 5,
    past_6_days: 6,
    past_1_weeks: 7,
    past_all: 8
  }

  # 友達数の絞り込み種別
  enum friends_filter_type: {
    one_or_more_friends: 0,
    two_or_more_friends: 1,
    three_or_more_friends: 2,
    four_or_more_friends: 3,
    five_or_more_friends: 4
  }
end
