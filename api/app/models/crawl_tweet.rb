# frozen_string_literal: true

class CrawlTweet < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :text, presence: true
  validates :tweeted_at, presence: true
end
