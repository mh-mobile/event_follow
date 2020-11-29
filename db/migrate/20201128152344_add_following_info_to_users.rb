# frozen_string_literal: true

class AddFollowingInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :folowing_last_updated_at, :datetime, null: true
    add_column :users, :following_next_cursor, :integer, null: false, default: -1
  end
end
