# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events, force: :cascade do |t|
      t.references :site, null: false, foreign_key: true
      t.integer :site_event_id, null: false
      t.string :title, null: false
      t.datetime :started_at, null: false
      t.datetime :ended_at, null: false
      t.string :banner, null: false
      t.string :url, null: false

      t.timestamps
      t.index ["site_id", "site_event_id"], name: "index_events_on_site_and_site_event_id", unique: true
    end
  end
end
