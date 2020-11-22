# frozen_string_literal: true

class DoorkeeperRequest
  include EventRequestable

  def initialize(api_client, ogp_client, event_url)
    @api_client = api_client
    @ogp_client = ogp_client
    @event_url = event_url
  end

  def request
  end
end
