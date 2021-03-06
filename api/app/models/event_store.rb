# frozen_string_literal: true

class EventStore
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :event_url
  attr_reader :event
  validates :event_url, presence: true

  def save
    return fales unless validate
    request_info = EventRequestable.parse(event_url)
    return false unless request_info

    @event = Event.find_by(site_id: request_info.site_id, site_event_id: request_info.site_event_id)
    unless @event
      request = EventRequestable.create(request_info)
      @event = request.request
      return false unless @event
      return false if @event&.ended_at < DateTime.current
      @event&.save
    else
      true
    end
  end
end
