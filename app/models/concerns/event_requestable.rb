# frozen_string_literal: true

module EventRequestable
  CONNPASS_EVENT_URL_REGEX = /(?<event_url>https:\/\/.*connpass.com\/event\/(?<event_id>\d+)\/)/
  DOORKEEPER_EVENT_URL_REGEX = /(?<event_url>https:\/\/.*doorkeeper.jp\/events\/(?<event_id>\d+))/
  TECHPLAY_EVENT_URL_REGEX = /(?<event_url>https:\/\/.*techplay.jp\/event\/(?<event_id>\d+))/

  def self.create(request_info)
    case request_info.site_id
    when Site::CONNPASS_EVENT_SITE_ID
      return ConnpassRequest.new(ConnpassClient.new, OgpClient.new, request_info.event_url, request_info.site_event_id)
    when Site::DOORKEEPER_EVENT_SITE_ID
      auth_token = ENV["DOORKEEPER_AUTH_TOKEN"]
      return DoorkeeperRequest.new(DoorkeeperClient.new(auth_token), OgpClient.new, request_info.event_url, request_info.site_event_id)
    when Site::TECHPLAY_EVENT_SITE_ID
      return TechPlayRequest.new(OgpClient.new, request_info.event_url, request_info.site_event_id)
    end

    nil
  end

  def self.parse(event_url)
    if match = event_url.match(CONNPASS_EVENT_URL_REGEX)
      return EventRequestInfo.new(Site::CONNPASS_EVENT_SITE_ID, match[:event_id], match[:event_url])
    end

    if match = event_url.match(DOORKEEPER_EVENT_URL_REGEX)
      return EventRequestInfo.new(Site::DOORKEEPER_EVENT_SITE_ID, match[:event_id], match[:event_url])
    end

    if match = event_url.match(TECHPLAY_EVENT_URL_REGEX)
      return EventRequestInfo.new(Site::TECHPLAY_EVENT_SITE_ID, match[:event_id], match[:event_url])
    end

    nil
  end

  def request
    raise "require to implement"
  end
end
