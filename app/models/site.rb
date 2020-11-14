# frozen_string_literal: true

class Site < ActiveRecord::Base
  has_many :events, dependent: :destroy

  validates :name, presence: true
end
