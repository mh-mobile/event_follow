# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventCleaner, type: :model do
  let!(:site_1) do
    FactoryBot.create(:site_1)
  end

  let!(:event_day_03_02) do
    FactoryBot.create(:event_template, :event_day_03_02, site: site_1)
  end

  let!(:event_day_03_03) do
    FactoryBot.create(:event_template, :event_day_03_03, site: site_1)
  end

  let!(:event_day_03_05) do
    FactoryBot.create(:event_template, :event_day_03_05, site: site_1)
  end

  let!(:event_day_03_06) do
    FactoryBot.create(:event_template, :event_day_03_06, site: site_1)
  end

  context "期日が過ぎていないイベント" do
    it "何も削除されない" do
      travel_to("2021-03-01 23:00".to_time)
      expect { EventCleaner.new.execute }.not_to change { Event.count }.from(4)
    end
  end

  context "期日が過ぎたイベント" do
    it "2件削除される" do
      travel_to("2021-03-04 23:00".to_time)
      expect { EventCleaner.new.execute }.to change { Event.count }.from(4).to(2)
    end
  end
end
