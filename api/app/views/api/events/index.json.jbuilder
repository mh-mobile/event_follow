# frozen_string_literal: true

json.array! @events do |event|
  json.partial! "api/events/event", event: event
end
