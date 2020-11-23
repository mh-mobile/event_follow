# frozen_string_literal: true

module EventDecorator
  MAX_LENGTH = 250

  def formatted_description
    striped = strip_tags(self.description)
    striped = striped[0, MAX_LENGTH] + "..." if striped.length > MAX_LENGTH
    striped
  end

  def logo
    case self.site_id
    when Site::CONNPASS_EVENT_SITE_ID
      image_tag "connpass_logo.png"
    when Site::DOORKEEPER_EVENT_SITE_ID
      image_tag "doorkeeper_logo.png"
    when Site::TECHPLAY_EVENT_SITE_ID
      image_tag ""
    end
  end
end
