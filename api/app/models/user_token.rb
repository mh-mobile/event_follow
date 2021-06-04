# frozen_string_literal: true

class UserToken < ApplicationRecord
  belongs_to :user
  encrypts :access_token
  encrypts :access_token_secret
end
