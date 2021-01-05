# frozen_string_literal: true

module EventCleanable
  extend ActiveSupport::Concern

  def target_events
    @target_events ||=begin
      Event.where.not(ended_at: Time.current..)
    end
  end
end
