# frozen_string_literal: true

require "active_record/fixtures"
require "factory_bot"

ActiveRecord::FixtureSet.create_fixtures \
  "db/fixtures",
  %i[sites]
