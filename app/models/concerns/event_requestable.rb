# frozen_string_literal: true

module EventRequestable
  extend ActiveSupport::Concern

  class_methods do
    def create(event_url)
    end
  end

  def request
    raise "require to implement"
  end
end
