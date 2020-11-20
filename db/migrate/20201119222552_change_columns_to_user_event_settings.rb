# frozen_string_literal: true

class ChangeColumnsToUserEventSettings < ActiveRecord::Migration[6.0]
  def change
    change_column_null :user_event_settings, :event_sort_type, false
    change_column_null :user_event_settings, :time_filter_type, false
    change_column_null :user_event_settings, :friends_filter_type, false
  end
end
