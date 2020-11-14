# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :follower
  belongs_to :followed
end
