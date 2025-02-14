# frozen_string_literal: true

require "rails_helper"

module Analytics
  RSpec.describe PrivateBetaAggregatedAnalyticsService do
    describe ".run" do
      subject(:result) { described_class.run(start_date: start_date, end_date: end_date) }

      let(:expected_structure) do
        {
          total_journeys_started: an_instance_of(Integer),
          back_office_started: an_instance_of(Integer),
          front_office_started: an_instance_of(Integer),
          total_journeys_completed: an_instance_of(Integer),
          completion_rate: an_instance_of(Float),
          front_office_completed: an_instance_of(Integer),
          back_office_completed: an_instance_of(Integer),
          cross_office_completed: an_instance_of(Integer),
          total_journeys_abandoned: an_instance_of(Integer),
          incomplete_journeys: an_instance_of(Integer)
        }
      end

      # get past the location page in all cases - this logic is tested in the base class
      let(:visited_pages) { %w[start_form location_form business_type_form] }
      let(:start_date) { 7.days.ago }
      let(:end_date) { Time.zone.today }

      before do
        create_list(:user_journey, 2, :registration, visited_pages:, created_at: 5.days.ago, completed_at: nil)
        create_list(:user_journey, 3, :charged_registration, visited_pages:, created_at: 3.days.ago, completed_at: 2.days.ago)
        create_list(:user_journey, 4, :charged_registration, visited_pages:, created_at: 3.days.ago, completed_at: nil)
        create_list(:user_journey, 2, :renewal, visited_pages:, created_at: 4.days.ago, completed_at: nil)
      end

      it { expect(result).to match(expected_structure) }
      it { expect(result[:total_journeys_started]).to eq(7) }
      it { expect(result[:total_journeys_completed]).to eq(3) }
      it { expect(result[:incomplete_journeys]).to eq(4) }
    end
  end
end
