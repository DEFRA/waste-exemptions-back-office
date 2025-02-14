# frozen_string_literal: true

require "rails_helper"

def time_diff(from_time, to_time)
  (to_time - from_time).seconds.round
end

module Analytics
  RSpec.describe PrivateBetaPageDwellTimesService do
    describe ".run" do
      subject(:result) { described_class.run(start_date:, end_date:) }

      let(:start_date) { 1.month.ago }
      let(:end_date) { 2.days.ago }

      # All within the date range by default
      let(:created_at) { start_date + 1.day }

      # Set a fixed time value from which to start measuring page times
      let(:start_time) { 1.week.ago }

      include_context "with user journeys with timed page views"

      it do
        expect(result["beta-start"]).to eq(
          (
            (time_diff(3.seconds, 3.minutes) +
            time_diff(7.seconds, 18.minutes) +
            time_diff(6.seconds, 7.minutes)
            ) / 3.0)
           .round
        )
      end

      it do
        expect(result["location"]).to eq(
          (
            (time_diff(3.minutes, 1.hour) +
            time_diff(18.minutes, 4.days)
            ) / 2.0)
           .round
        )
      end

      it do
        expect(result["operator-name"]).to eq(
          (
            (time_diff(1.hour, 2.days) +
            time_diff(7.minutes, 25.hours)
            ) / 2.0)
           .round
        )
      end

      # nil because there is no subsequent page visit
      it { expect(result["declaration"]).to be_nil }

      # nil because no such page was visited
      it { expect(result["E"]).to be_nil }
    end
  end
end
