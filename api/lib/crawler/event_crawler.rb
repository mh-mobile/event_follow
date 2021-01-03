# frozen_string_literal: true

class EventCrawler
  include EventCrawlable

  def start
    return unless crawl_tweet

    event_store = EventStore.new({ event_url: crawl_tweet.event_url })
    if event_store.save
      update_tweet(event_store.event.id, crawl_tweet)
    end
    delete_crawl_tweet(crawl_tweet)
  end
end
