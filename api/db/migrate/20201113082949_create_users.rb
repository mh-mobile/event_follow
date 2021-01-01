# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, force: :cascade, id: false do |t|
      t.string :id, null: false
      t.string :screen_name, null: false
      t.string :name, null: false
      t.string :profile_image, null: false
      t.string :uid
    end

    reversible do |direction|
      direction.up { execute "ALTER TABLE users ADD PRIMARY KEY (id);" }
    end
    add_index :users, [:uid], unique: true
  end
end
