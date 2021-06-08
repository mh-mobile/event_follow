# frozen_string_literal: true

class API::UsersController < API::BaseController
  def destroy
    delete_user_session
    head :no_content
  end

  private
    # 他のTwitterユーザーからフォローされている可能性があるため、
    # カレントユーザー自体はUsersテーブルから削除しない
    def delete_user_session
      current_user.user_event_setting = nil
      current_user.user_token = nil
      current_user.friendships.delete_all
      current_user.uid = nil
      current_user.save!
    end
end
