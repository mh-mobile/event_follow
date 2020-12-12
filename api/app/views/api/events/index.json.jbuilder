# frozen_string_literal: true

json.meta do
  json.current_page @events.current_page
  json.prev_page @events.prev_page
  json.next_page @events.next_page
  json.limit_value @events.limit_value
  json.pages @events.total_pages
  json.count @events.total_count
end

json.data do
  json.array! @data do |event_data|
    json.partial! "api/events/event", event_data: event_data
  end
end
