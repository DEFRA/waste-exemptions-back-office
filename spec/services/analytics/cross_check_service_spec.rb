# frozen_string_literal: true

require "rails_helper"

module Analytics
  RSpec.describe CrossCheckService do
    describe ".run" do
      subject(:result) { described_class.run(start_date: start_date, end_date: end_date) }

      let(:start_date) { 7.days.ago.to_date }
      let(:end_date) { Time.zone.today }

      let(:expected_structure) do
        {
          reg_total: an_instance_of(Integer),
          reg_fo: an_instance_of(Integer),
          reg_bo: an_instance_of(Integer),
          analytics_total: an_instance_of(Integer),
          analytics_fo: an_instance_of(Integer),
          analytics_bo: an_instance_of(Integer)
        }
      end

      it { expect(result).to match(expected_structure) }

      context "with registrations in the date range" do
        before do
          create_list(:registration, 2, submitted_at: 3.days.ago)
          create(:registration, submitted_at: 3.days.ago, assistance_mode: "full")
          create(:registration, submitted_at: 10.days.ago)
        end

        it { expect(result[:reg_total]).to eq(3) }
        it { expect(result[:reg_fo]).to eq(2) }
        it { expect(result[:reg_bo]).to eq(1) }
      end

      context "with analytics journeys in the date range" do
        before do
          create_list(:user_journey, 2, :completed_digital, completed_at: 3.days.ago)
          create(:user_journey, :completed_assisted_digital, completed_at: 3.days.ago)
          create(:user_journey, :renewal, :completed_digital, completed_at: 5.days.ago)
          create(:user_journey, :charged_registration, :completed_digital, completed_at: 5.days.ago)
        end

        it { expect(result[:analytics_total]).to eq(5) }
        it { expect(result[:analytics_fo]).to eq(4) }
        it { expect(result[:analytics_bo]).to eq(1) }
      end

      context "when journeys are outside the date range" do
        before do
          create(:user_journey, :completed_digital, completed_at: 10.days.ago)
        end

        it { expect(result[:analytics_total]).to eq(0) }
      end

      context "when the journey type is an edit" do
        before do
          create(:user_journey, :completed_digital, journey_type: "FrontOfficeEditRegistration", completed_at: 3.days.ago)
          create(:user_journey, :completed_digital, journey_type: "BackOfficeEditRegistration", completed_at: 3.days.ago)
        end

        it { expect(result[:analytics_total]).to eq(0) }
      end

      context "when the last page view is a redirect page" do
        before do
          journey = create(:user_journey, :completed_digital, completed_at: 3.days.ago)
          journey.page_views.create!(page: "business_type_form", time: 4.days.ago, route: "DIGITAL")
          journey.page_views.create!(page: "register_in_wales_form", time: 3.days.ago, route: "DIGITAL")

          included_journey = create(:user_journey, :completed_digital, completed_at: 3.days.ago)
          included_journey.page_views.create!(page: "register_in_wales_form", time: 4.days.ago, route: "DIGITAL")
          included_journey.page_views.create!(page: "business_type_form", time: 3.days.ago, route: "DIGITAL")
        end

        it "excludes journeys ending on a redirect page" do
          expect(result[:analytics_total]).to eq(1)
        end
      end

      context "when no data is available for the date range" do
        let(:start_date) { 30.days.ago.to_date }
        let(:end_date) { 21.days.ago.to_date }

        before do
          create(:registration, submitted_at: 31.days.ago)
          create(:user_journey, :completed_digital, completed_at: 20.days.ago)
        end

        it { expect(result).to match(expected_structure) }
        it { expect(result.values).to all(be_zero) }
      end
    end
  end
end
