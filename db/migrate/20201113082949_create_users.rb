# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, force: :cascade, id: false do |t|
      t.bigint :id, null: false
      t.string :screen_name, null: false
      t.string :name, null: false
      t.string :profile_image, null: false
    end

    reversible do |direction|
      direction.up { execute "ALTER TABLE users ADD PRIMARY KEY (id);" }
    end
  end
end
