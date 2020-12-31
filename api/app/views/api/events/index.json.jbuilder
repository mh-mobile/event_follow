# frozen_string_literal: true

json.meta do
  json.current_page @events.current_page
  json.prev_page @events.prev_page
  json.next_page @events.next_page
  json.limit_value @events.limit_value
  json.total_pages @events.total_pages
  json.total_count @events.total_count
  json.event_sort_type @event_sort_type
  json.time_filter_type @time_filter_type
  json.friends_filter_type @friends_filter_type
end

json.data do
  json.array! @data do |event_data|
    json.partial! "api/events/event", event_data: event_data
  end
end
