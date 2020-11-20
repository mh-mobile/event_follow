# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :require_login
  before_action :set_sort_filter_condition

  def index
    @events = Event.following_events(current_user).page(params[:page]).preload(tweets: :user)
  end

  private
    def set_sort_filter_condition
      user_event_setting = current_user.user_event_setting

      begin
        user_event_setting.update(
          event_sort_type: params[:sort],
          time_filter_type: params[:time],
          friends_filter_type: params[:friends])
        user_event_setting.reload
      rescue ArgumentError
        redirect_to authenticated_root_path
      end

      @event_sort_type = user_event_setting.event_sort_type
      @time_filter_type = user_event_setting.time_filter_type
      @friends_filter_type = user_event_setting.friends_filter_type
    end
end
