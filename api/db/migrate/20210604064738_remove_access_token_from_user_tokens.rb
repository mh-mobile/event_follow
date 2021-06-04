# frozen_string_literal: true

class RemoveAccessTokenFromUserTokens < ActiveRecord::Migration[6.1]
  def up
    remove_column :user_tokens, :access_token, :string
  end

  def down
    add_column :user_tokens, :access_token, :string
  end
end
