# frozen_string_literal: true

class ConnpassRequest
  include EventRequestable

  def initialize(api_client, ogp_client, event_url)
    @api_client = api_client
    @ogp_client = ogp_client
    @event_url = event_url
    byebug
    if match = event_url.match(/https:\/\/.*connpass.com\/event\/(?<event_id>.*)\//)
      @event_id = match[:event_id]
    end
  end

  def request
    event = @api_client.search(@event_id).events[0]
    ogp_res = @ogp_client.search(@event_url)
    Event.new(site_id: 1,
        site_event_id: event.event_id,
        title: event.title,
        description: event.description,
        started_at: event.started_at,
        ended_at: event.ended_at,
        url: event.event_url,
        banner: ogp_res.image.url)
  end
end
