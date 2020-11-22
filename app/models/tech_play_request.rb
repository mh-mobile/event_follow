# frozen_string_literal: true

class TechPlayRequest
  include EventRequestable

  def initialize(ogp_client, event_url)
    @ogp_client = ogp_client
    @event_url = event_rul
  end

  def request
  end
end
