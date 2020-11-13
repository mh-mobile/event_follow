class CreateUserTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :access_token, null: false
      t.string :access_token_secret, null: false

      t.timestamps
    end
  end
end
