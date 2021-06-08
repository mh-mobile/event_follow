# frozen_string_literal: true

class API::EventsController < API::BaseController
  before_action :set_sort_filter_condition

  def index
    @events = Event.following_events(current_user).page(params[:page]).preload(tweets: :user)
    following = current_user.following.ids
    @data = Event.convert_events(@events, following)
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
        # [ArgumentErrorの補足理由]
        # enumの設定値にない不正な検索条件の値は設定値の更新時にArgumentErrorが発生する。
        # ArgumentErrorの場合は、デフォルトの検索条件を以降で設定する。
      end

      @event_sort_type = user_event_setting.event_sort_type
      @time_filter_type = user_event_setting.time_filter_type
      @friends_filter_type = user_event_setting.friends_filter_type
    end
end
