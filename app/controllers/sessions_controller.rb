# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    if auth.present?
      user = User.find_or_create_from_auth(request.env["omniauth.auth"])
      log_in(user)
      flash[:success] = "ログインしました。"
      redirect_to authenticated_root_path
    else
      flash.now[:danger] = "ログインに失敗しました"
      redirect_to unauthenticated_root_path
    end
  end

  def destory
    log_out
    redirect_to unauthenticated_root_path
  end
end
