# frozen_string_literal: true

class ConnpassRequest
  include EventRequestable

  def initialize(api_client, ogp_client, event_url, event_id)
    @api_client = api_client
    @ogp_client = ogp_client
    @event_url = event_url
    @event_id = event_id
  end

  def request
    event = @api_client.search(@event_id).events[0]
    return nil unless event
    ogp_res = @ogp_client.search(@event_url)
    return nil unless ogp_res
    Event.new(site_id: Site::CONNPASS_EVENT_SITE_ID,
        site_event_id: @event_id,
        title: event.title,
        description: event.description,
        started_at: event.started_at,
        ended_at: event.ended_at,
        url: event.event_url,
        banner: ogp_res.image.url)
  end
end
