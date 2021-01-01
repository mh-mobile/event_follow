# frozen_string_literal: true

class CreateUserTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tokens do |t|
      t.string :user_id, null: false
      t.string :access_token, null: false
      t.string :access_token_secret, null: false

      t.timestamps
    end
    add_foreign_key :user_tokens, :users
    add_index :user_tokens, :user_id
  end
end
