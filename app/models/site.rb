# frozen_string_literal: true

class Site < ActiveRecord::Base
  CONNPASS_EVENT_SITE_ID = 1
  DOORKEEPER_EVENT_SITE_ID = 2
  TECHPLAY_EVENT_SITE_ID = 3

  has_many :events, dependent: :destroy

  validates :name, presence: true
end
