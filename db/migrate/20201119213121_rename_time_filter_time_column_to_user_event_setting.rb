# frozen_string_literal: true

class RenameTimeFilterTimeColumnToUserEventSetting < ActiveRecord::Migration[6.0]
  def change
    rename_column :user_event_settings, :time_filter_time, :time_filter_type
  end
end
