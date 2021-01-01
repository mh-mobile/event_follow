# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.string :follower_id, null: false
      t.string :followed_id, null: false

      t.timestamps
      t.index ["follower_id", "followed_id"], name: "index_friendships_on_follower_id_and_followed_id", unique: true
    end

    add_foreign_key :friendships, :users, column: :follower_id
    add_foreign_key :friendships, :users, column: :followed_id
  end
end
