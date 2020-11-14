class CreateUserEventSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :user_event_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :event_sort_type, default: 0
      t.integer :time_filter_time, default: 1
      t.integer :friends_filter_type, default: 0

      t.timestamps
    end
  end
end
