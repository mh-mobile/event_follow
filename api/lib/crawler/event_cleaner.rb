# frozen_string_literal: true

class EventCleaner
  include EventCleanable

  def execute
    target_events.destroy_all
  end
end
