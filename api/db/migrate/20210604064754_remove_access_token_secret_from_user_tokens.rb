# frozen_string_literal: true

class RemoveAccessTokenSecretFromUserTokens < ActiveRecord::Migration[6.1]
  def up
    remove_column :user_tokens, :access_token_secret, :string
  end

  def down
    add_column :user_tokens, :access_token_secret, :string
  end
end
