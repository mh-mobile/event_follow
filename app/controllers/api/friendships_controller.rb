# frozen_string_literal: true

class Api::FriendshipsController < Api::BaseController
  def index
    @users = current_user.following
  end
end
  