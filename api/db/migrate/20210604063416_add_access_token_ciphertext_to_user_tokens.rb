# frozen_string_literal: true

class AddAccessTokenCiphertextToUserTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :user_tokens, :access_token_ciphertext, :text
  end
end
