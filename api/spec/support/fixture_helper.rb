# frozen_string_literal: true

module FixtureHelper
  def read_fixture_json(filename)
    File.open(File.dirname(__FILE__) + "/../fixtures/" + filename, "rb").read
  end
end
