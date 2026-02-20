# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BulkExportService do
    describe ".run" do
      let(:number_of_months) { 13 }

      before do
        allow(GeneratedReport).to receive(:bulk).and_return(GeneratedReport)
        allow(GeneratedReport).to receive(:delete_all)
        allow(MonthlyBulkReportService).to receive(:run)
      end

      it "clears out all existing records from the database" do
        create(:registration)

        described_class.run

        expect(GeneratedReport).to have_received(:delete_all)
      end

      it "executes a MonthlyBulkReportService for every month since the first registration was submitted" do
        create(:registration, submitted_at: number_of_months.months.ago)

        described_class.run

        expect(MonthlyBulkReportService).to have_received(:run).exactly(number_of_months + 1).times
      end

      context "when there are no registrations to report" do
        it "exits and does nothing" do
          described_class.run

          expect(GeneratedReport).not_to have_received(:delete_all)
          expect(MonthlyBulkReportService).not_to have_received(:run)
        end
      end
    end
  end
end
