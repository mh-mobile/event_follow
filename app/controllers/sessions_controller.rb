class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    if auth.present?
      user = User.find_or_create_from_auth(request.env["omniauth.auth"])
      session[:user_id] = user.id
      flash[:success] = "ログインしました。"
      redirect_to authenticated_root_path
    else
      flash.now[:danger] = "ログインに失敗しました"
      redirect_to unauthenticated_root_path
    end
  end
end
