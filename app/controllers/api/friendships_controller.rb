# frozen_string_literal: true

class Api::FriendshipsController < Api::BaseController
  def index
    user_ids = find_user_ids
    @users = User.where(id: find_user_ids)
  end

  private
    def find_user_ids
      user_ids = params[:user_ids]
      if user_ids.present? && user_ids.split(",").count > 0
        user_ids.split(",")
      else
        @user_ids = []
      end
    end
end
