# frozen_string_literal: true

class DoorkeeperRequest
  include EventRequestable

  def initialize(api_client, ogp_client, event_url)
    @api_client = api_client
    @ogp_client = ogp_client
    @event_url = event_url
    if match = event_url.match(/https:\/\/.*doorkeeper.jp\/events\/(?<event_id>\d+)/)
      @event_id = match[:event_id]
    end
  end

  def request
    event = @api_client.search(@event_id).event
    ogp_res = @ogp_client.search(@event_url)
    Event.new(site_id: 2,
        site_event_id: event.id,
        title: event.title,
        description: event.description,
        started_at: event.starts_at,
        ended_at: event.ends_at,
        url: event.public_url,
        banner: ogp_res.image.url)
  end
end
