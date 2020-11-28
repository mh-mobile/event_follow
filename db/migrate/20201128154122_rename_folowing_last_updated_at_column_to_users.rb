# frozen_string_literal: true

class RenameFolowingLastUpdatedAtColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :folowing_last_updated_at, :following_last_updated_at
  end
end
