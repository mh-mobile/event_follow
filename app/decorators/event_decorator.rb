# frozen_string_literal: true

module EventDecorator
  MAX_LENGTH = 250

  def formatted_description
    striped = strip_tags(self.description)
    striped = striped[0, MAX_LENGTH] + "..." if striped.length > MAX_LENGTH
    striped
  end
end
