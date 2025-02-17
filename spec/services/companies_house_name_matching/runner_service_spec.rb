# frozen_string_literal: true

require "rails_helper"

module CompaniesHouseNameMatching
  RSpec.describe RunnerService do
    describe ".run_until_done" do
      let(:report_path) { Rails.root.join("tmp/test_report.csv") }

      before do
        allow(ProcessBatch).to receive(:run).and_return({})
        allow(described_class).to receive(:sleep).and_return(nil)
      end

      after do
        FileUtils.rm_f(report_path)
      end

      context "when there are multiple batches to process" do
        before do
          allow(ProcessBatch).to receive(:run)
            .and_return(
              {
                processed_company_count: 5,
                skipped_company_count: 2,
                total_left_to_process: 10,
                any_left_to_process?: true # Still more to process
              },
              {
                processed_company_count: 10,
                skipped_company_count: 0,
                total_left_to_process: 0,
                any_left_to_process?: false # none left to process
              }
            )
        end

        it "processes all batches" do
          described_class.run_until_done(dry_run: true, report_path: report_path)

          expect(ProcessBatch).to have_received(:run).twice
        end

        it "respects the rate limit by sleeping between batches" do

          described_class.run_until_done(dry_run: true, report_path: report_path)
          expect(described_class).to have_received(:sleep).with(ProcessBatch::TIME_BETWEEN_BATCHES).once
        end
      end

      context "when there are no companies to process" do
        before do
          allow(ProcessBatch).to receive(:run)
            .and_return(
              {
                processed_company_count: 0,
                skipped_company_count: 0,
                total_left_to_process: 0,
                any_left_to_process?: false
              }
            )
        end

        it "exits after one batch" do
          described_class.run_until_done(dry_run: true, report_path: report_path)

          expect(ProcessBatch).to have_received(:run).once
        end

        it "does not sleep between batches" do
          described_class.run_until_done(dry_run: true, report_path: report_path)

          expect(described_class).not_to have_received(:sleep)
        end
      end

      it "passes through the dry_run parameter" do
        described_class.run_until_done(dry_run: true, report_path: report_path)

        expect(ProcessBatch).to have_received(:run).with(
          hash_including(dry_run: true)
        )
      end

      it "passes through the report_path parameter" do
        described_class.run_until_done(dry_run: true, report_path: report_path)

        expect(ProcessBatch).to have_received(:run).with(
          hash_including(report_path: report_path)
        )
      end
    end
  end
end
