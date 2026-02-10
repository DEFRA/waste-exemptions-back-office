# frozen_string_literal: true

require "rails_helper"

module Analytics
  RSpec.describe DropoffPagesService do
    describe ".run" do
      subject(:result) { described_class.run(start_date:, end_date:) }

      let(:start_date) { 1.month.ago }
      let(:end_date) { 2.days.ago }

      # All within the date range by default
      let(:created_at) { 1.week.ago }

      # All abandoned by default
      let(:updated_at) { 3.days.ago }

      before do
        # before date range, charged, abandoned
        create_list(:user_journey, 4, :charged_registration,
                    visited_pages: %w[start_form location_form business_type_form],
                    created_at: start_date - 1.day, updated_at:, completed_at: nil)
        # after date range, charged, abandoned
        create_list(:user_journey, 3, :charged_registration,
                    visited_pages: %w[start_form location_form business_type_form],
                    created_at: end_date + 1.day, updated_at:, completed_at: nil)
        # Not past location page, charged, abandoned
        create_list(:user_journey, 2, :charged_registration,
                    visited_pages: %w[start_form location_form],
                    created_at:, updated_at:, completed_at: nil)
        # Past location page, non-charged, abandoned
        create_list(:user_journey, 3, :renewal,
                    visited_pages: %w[start_form location_form business_type_form],
                    created_at:, updated_at:, completed_at: nil)
        # Past location page, charged, not abandoned
        create_list(:user_journey, 4, :charged_registration,
                    visited_pages: %w[start_form location_form business_type_form],
                    created_at:, updated_at: 1.hour.ago, completed_at: nil)
        # Past location page, charged, abandoned
        create_list(:user_journey, 5, :charged_registration,
                    visited_pages: %w[start_form location_form business_type_form],
                    created_at:, updated_at: 50.hours.ago, completed_at: nil)
        # To declaration page, non-charged, abandoned
        create_list(:user_journey, 5, :renewal,
                    visited_pages: %w[start_form location_form business_type_form declaration_form],
                    created_at:, updated_at:, completed_at: nil)
        # To declaration page, charged, abandoned
        create_list(:user_journey, 7, :charged_registration,
                    visited_pages: %w[start_form location_form business_type_form declaration_form],
                    created_at:, updated_at:, completed_at: nil)
        # Completed, non-charged, last updated meets definition of abanoned
        create_list(:user_journey, 8, :renewal,
                    visited_pages: %w[start_form location_form registration_complete_form],
                    created_at:, updated_at:, completed_at: 3.days.ago)
        # Completed, charged, last updated meets definition of abanoned
        create_list(:user_journey, 9, :charged_registration,
                    visited_pages: %w[start_form location_form registration_complete_form],
                    created_at:, updated_at:, completed_at: 3.days.ago)
      end

      # hasn't passed start_cutoff_page yet
      it { expect(result["start"]).to be_nil }
      # hasn't passed start_cutoff_page yet
      it { expect(result["location"]).to be_nil }
      it { expect(result["business-type"]).to eq 8 }
      it { expect(result["exemptions"]).to be_nil }
      it { expect(result["declaration"]).to eq 12 }
      # Completion pages are not dropoff pages
      it { expect(result["registration-complete"]).to be_nil }
    end
  end
end
