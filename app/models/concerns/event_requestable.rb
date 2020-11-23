# frozen_string_literal: true

module EventRequestable
  def self.create(event_url)
    if match = event_url.match(/(?<event_url>https:\/\/.*connpass.com\/event\/(?<event_id>\d+)\/)/)
      return ConnpassRequest.new(ConnpassClient.new, OgpClient.new, match[:event_url], match[:event_id])
    end

    if match = event_url.match(/(?<event_url>https:\/\/.*doorkeeper.jp\/events\/(?<event_id>\d+))/)
      auth_token = ENV["DOORKEEPER_AUTH_TOKEN"]
      return DoorkeeperRequest.new(DoorkeeperClient.new(auth_token), OgpClient.new, match[:event_url], match[:event_id])
    end

    if match = event_url.match(/(?<event_url>https:\/\/.*techplay.jp\/event\/(?<event_id>\d+))/)
      return TechPlayRequest.new(OgpClient.new, match[:event_url], match[:event_id])
    end

    nil
  end

  def request
    raise "require to implement"
  end
end
