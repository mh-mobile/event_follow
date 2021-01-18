# frozen_string_literal: true

class EventCrawler
  include EventCrawlable

  def execute
    return unless crawl_tweet

    event_store = EventStore.new({ event_url: crawl_tweet.event_url })
    begin
      if event_store.save
        update_tweet(event_store.event.id, crawl_tweet)
      end
    rescue Faraday::ResourceNotFound => error
      puts "error: #{error}"
    ensure
      delete_crawl_tweet(crawl_tweet)
    end
  end
end
