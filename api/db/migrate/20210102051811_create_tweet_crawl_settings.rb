class CreateTweetCrawlSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :tweet_crawl_settings do |t|
      t.string :max_id, null: false, default: 0
      t.string :since_id, null: false, default: 0
      t.string :search_base_max_id, null: false, default: 0

      t.timestamps
    end
  end
end
