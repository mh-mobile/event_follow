class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :uid, default: "", null: false
      t.string :provider, default: "", null: false

      t.timestamps
      t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

    end
  end
end
