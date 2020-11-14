# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :user_signed_in?
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    !current_user.nil?
  end

  def require_login
    redirect_to unauthenticated_root_path unless user_signed_in?
  end
end
