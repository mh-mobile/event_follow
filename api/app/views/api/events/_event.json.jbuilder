# frozen_string_literal: true

json.event do
  json.(event_data[:event], :id, :site_id, :site_event_id, :title, :started_at, :ended_at, :banner, :url, :description)
end

json.extra do
  json.(event_data[:extra], :user_ids, :friends_number)
end
