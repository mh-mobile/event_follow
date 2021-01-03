# frozen_string_literal: true

class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_user

  def create
    FirebaseIdToken::Certificates.request
    if validate_auth?
      @user = User.find_or_create_from_auth(payload: payload,
                                            access_token: access_token,
                                            access_token_secret: access_token_secret)
    else
      @error_message = "認証情報が不正です"
    end
  end

  private
    def token_from_reqauest_headers
      request.headers["Authroization"]&.split&.last
    end

    def token
      params[:token] || token_from_reqauest_headers
    end

    def access_token
      @access_token ||= params[:access_token]
    end

    def access_token_secret
      @access_token_secret ||= params[:access_token_secret]
    end

    def payload
      @payload ||= FirebaseIdToken::Signature.verify token
    end

    def validate_auth?
      payload.present? && access_token.present? && access_token_secret.present?
    end
end
