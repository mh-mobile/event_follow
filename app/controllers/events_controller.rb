# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :require_login

  def index
    @events = Event.page(params[:page]).preload(tweets: :user)
  end
end
