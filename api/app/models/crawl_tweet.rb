# frozen_string_literal: true

class CrawlTweet < ApplicationRecord
  belongs_to :user

  validates :text, presence: true
  validates :tweeted_at, presence: true
end
