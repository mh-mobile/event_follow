# frozen_string_literal: true

class AddAccessTokenSecretCiphertextToUserTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :user_tokens, :access_token_secret_ciphertext, :text
  end
end
