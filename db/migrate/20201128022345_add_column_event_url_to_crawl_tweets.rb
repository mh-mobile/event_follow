class AddColumnEventUrlToCrawlTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :crawl_tweets, :event_url, :string, null: false
  end
end
