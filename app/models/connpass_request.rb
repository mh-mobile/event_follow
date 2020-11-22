# frozen_string_literal: true

class ConnpassRequest
  include EventRequestable

  def initialize(api_client, ogp_client, event_url)
    @api_client = api_client
    @ogp_client = ogp_client
  end

  def request
  end
end
