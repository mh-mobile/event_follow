# frozen_string_literal: true

require_relative "../config/boot"
require_relative "../config/environment"
require "clockwork"

module Clockwork
  handler do |job|
    case job
    when "frequent.job"
      puts "5秒ごとの処理"
    when "less.frequent.job"
      puts "1分ごとの処理"
    end
  end

  every(5.seconds, "frequent.job", thread: true)
  every(1.minutes, "less.frequent.job", thread: true)
end
