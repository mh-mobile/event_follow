# frozen_string_literal: true

class Api::EventsController < Api::BaseController
  def index
    @events = Event.all
  end
end
