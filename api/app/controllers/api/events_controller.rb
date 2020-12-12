# frozen_string_literal: true

class Api::EventsController < Api::BaseController
#  before_action :require_login
  before_action :set_sort_filter_condition

  def index
    current_user = User.find(1)
    # @events = Event.following_events(current_user).page(params[:page]).preload(tweets: :user)
    @events = Event.all.page(params[:page]).preload(tweets: :user)
    # following = current_user.following.ids

    @data = @events.map.with_index do |event, index|
      friend_user_ids = event.tweets.pluck(:user_id).uniq.select do |user_id|
        # following.include?(user_id)
        true
      end
      {
        event: event,
        extra: {
          user_ids: friend_user_ids.join(","),
          friends_number: friend_user_ids.length
        }
      }
    end

  end

  private
    def set_sort_filter_condition
      current_user = User.find(1)
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
