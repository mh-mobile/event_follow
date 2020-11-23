# frozen_string_literal: true

class DoorkeeperRequest
  include EventRequestable

  def initialize(api_client, ogp_client, event_url, event_id)
    @api_client = api_client
    @ogp_client = ogp_client
    @event_url = event_url
    @event_id = event_id
  end

  def request
    event = @api_client.search(@event_id).event
    ogp_res = @ogp_client.search(@event_url)
    Event.new(site_id: Site::DOORKEEPER_EVENT_SITE_ID,
        site_event_id: event.id,
        title: event.title,
        description: event.description,
        started_at: event.starts_at,
        ended_at: event.ends_at,
        url: event.public_url,
        banner: ogp_res.image.url)
  end
end
