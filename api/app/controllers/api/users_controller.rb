# frozen_string_literal: true

class Api::UsersController < Api::BaseController

  def destroy
    delete_user_session
    head :no_content
  end

  private
    def delete_user_session
      current_user.user_event_setting = nil
      current_user.user_token = nil
      current_user.friendships.delete_all
      current_user.uid = nil
      current_user.save!
    end
end
