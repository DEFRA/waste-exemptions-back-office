# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "companies_house_name_matching" do
  describe "batch tasks" do
    before do
      allow(CompaniesHouseNameMatching::ProcessBatch).to receive(:run)
    end

    describe "companies_house_name_matching:dry_run_batch" do
      before do
        Rake::Task["companies_house_name_matching:dry_run_batch"].reenable
      end

      it "runs the service in dry run mode" do
        Rake::Task["companies_house_name_matching:dry_run_batch"].invoke("test_report.csv")

        expect(CompaniesHouseNameMatching::ProcessBatch).to have_received(:run).with(
          dry_run: true,
          report_path: "test_report.csv"
        )
      end
    end

    describe "companies_house_name_matching:run_batch" do
      before do
        Rake::Task["companies_house_name_matching:run_batch"].reenable
      end

      it "runs the service in live mode" do
        Rake::Task["companies_house_name_matching:run_batch"].invoke("test_report.csv")

        expect(CompaniesHouseNameMatching::ProcessBatch).to have_received(:run).with(
          dry_run: false,
          report_path: "test_report.csv"
        )
      end
    end
  end

  describe "run_until_done tasks" do
    before do
      allow(CompaniesHouseNameMatching::RunnerService).to receive(:run_until_done)
    end

    describe "companies_house_name_matching:dry_run_until_done" do
      before do
        Rake::Task["companies_house_name_matching:dry_run_until_done"].reenable
      end

      it "runs the service in dry run mode" do
        Rake::Task["companies_house_name_matching:dry_run_until_done"].invoke("test_report.csv")

        expect(CompaniesHouseNameMatching::RunnerService).to have_received(:run_until_done).with(
          dry_run: true,
          report_path: "test_report.csv"
        )
      end
    end

    describe "companies_house_name_matching:run_until_done" do
      before do
        Rake::Task["companies_house_name_matching:run_until_done"].reenable
      end

      it "runs the service in live mode" do
        Rake::Task["companies_house_name_matching:run_until_done"].invoke("test_report.csv")

        expect(CompaniesHouseNameMatching::RunnerService).to have_received(:run_until_done).with(
          dry_run: false,
          report_path: "test_report.csv"
        )
      end
    end
  end
end
