# frozen_string_literal: true

module EventRequestable
  def self.create(event_url)
    if event_url.include?("connpass.com/event/")
      return ConnpassRequest.new(ConnpassClient.new, OgpClient.new, event_url)
    end

    if event_url.include?("doorkeeper.jp/events/")
      auth_token = ENV["DOORKEEPER_AUTH_TOKEN"]
      return DoorkeeperRequest.new(DoorkeeperClient.new(auth_token), OgpClient.new, event_url)
    end

    if event_url.include?("techplay.jp/event/")
      return TechPlayRequest.new(OgpClient.new, event_url)
    end

    nil
  end

  def request
    raise "require to implement"
  end
end
