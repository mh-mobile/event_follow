# frozen_string_literal: true

class API::FriendshipsController < API::BaseController
  def index
    @users = User.where(id: find_user_ids)
  end

  private
    def find_user_ids
      user_ids = params[:user_ids]
      exists?(user_ids) ? user_ids.split(",") : []
    end

    def exists?(user_ids)
      user_ids.present? && user_ids.split(",").count > 0
    end
end
