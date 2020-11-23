# frozen_string_literal: true

class TechPlayRequest
  include EventRequestable

  EVENT_DAY_XPATH = "//time[@class='eventAside-day']"
  EVENT_START_XPATH = "//time[@class='eventAside-day']"
  EVENT_END_XPATH = "//time[@class='eventAside-day']"

  def initialize(ogp_client, event_url, event_id)
    @ogp_client = ogp_client
    @event_url = event_url
    @event_id = event_id
  end

  def request
    ogp_res = @ogp_client.search(@event_url)
    event_datetime = extract_event_datetime
    Event.new(site_id: 3,
        site_event_id: @event_id,
        title: ogp_res.title,
        description: ogp_res.description,
        started_at: event_datetime[:started_at],
        ended_at: event_datetime[:eneded_at],
        url: ogp_res.url,
        banner: ogp_res.image.url)
  end

  private
    def extract_event_datetime
      doc = Nokogiri::HTML.parse(@ogp_client.body, nil, "utf-8")
      day_datetime = extract_datetime_from_element(doc.xpath(EVENT_DAY_XPATH)[0])
      start_datetime = extract_datetime_from_element(doc.xpath(EVENT_START_XPATH)[0])
      end_datetime = extract_datetime_from_element(doc.xpath(EVENT_END_XPATH)[0])
      {
        started_at: convert_to_iso8601_format("#{day_datetime} #{start_datetime} +0900"),
        ended_at: convert_to_iso8601_format("#{day_datetime} #{end_datetime} +0900")
      }
    end

    def convert_to_iso8601_format(datetime)
      DateTime.parse(datetime).utc.iso8601
    end

    def extract_datetime_from_element(element)
      element.attributes["datetime"].value
    end
end
