# frozen_string_literal: true

class CreateUserEventSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :user_event_settings do |t|
      t.string :user_id, null: false
      t.integer :event_sort_type, default: 0
      t.integer :time_filter_time, default: 1
      t.integer :friends_filter_type, default: 0

      t.timestamps
    end

    add_foreign_key :user_event_settings, :users
    add_index :user_event_settings, :user_id
  end
end
