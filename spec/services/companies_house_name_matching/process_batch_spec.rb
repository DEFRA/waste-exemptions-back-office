# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompaniesHouseNameMatching::ProcessBatch, type: :service do
  subject(:run_service) { batch_service.run(dry_run:, report_path:) }

  let(:batch_service) { described_class.new }
  let(:report_path) { Rails.root.join("tmp/test_report.csv") }
  let(:summary_path) { Rails.root.join("tmp/test_report_summary.csv") }
  let(:dry_run) { true }
  let(:max_requests) { (described_class::RATE_LIMIT * described_class::RATE_LIMIT_BUFFER).to_i }
  let(:companies_house_api) { instance_double(DefraRuby::CompaniesHouse::API) }

  original_stdout = $stdout # rubocop:disable RSpec/LeakyLocalVariable

  # rubocop:disable RSpec/ExpectOutput
  before do
    allow(DefraRuby::CompaniesHouse::API).to receive(:new).and_return(companies_house_api)
    allow(companies_house_api).to receive(:run).and_return(
      {
        company_name: "COMPANY NAME",
        registered_office_address: ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"]
      }
    )

    # Suppress noisy console output when unit testing
    $stdout = StringIO.new
  end

  after do
    $stdout = original_stdout

    FileUtils.rm_f(report_path)
    FileUtils.rm_f(summary_path)
  end
  # rubocop:enable RSpec/ExpectOutput

  describe "#run" do
    context "when generating reports" do
      before do
        create(:registration, operator_name: "Acme Group Ltd", company_no: "11111111")
      end

      it "creates a CSV report with correct headers" do
        run_service
        expect(File.exist?(report_path)).to be true

        headers = CSV.read(report_path)[3]
        expect(headers).to eq(
          ["Registration Ref", "Company Number", "Current Name",
           "Companies House Name", "Similarity Score", "Status"]
        )
      end

      it "creates a summary report with batch information" do
        run_service
        expect(File.exist?(summary_path)).to be true

        summary_content = CSV.read(summary_path)
        expect(summary_content[0]).to eq([
                                           "Batch #",
                                           "Started at",
                                           "Completed at",
                                           "Processed",
                                           "Updated",
                                           "Skipped"
                                         ])

        data_row = summary_content[1]
        expect(data_row[3..5].map(&:to_i)).to all(be >= 0)
      end
    end

    context "when processing companies" do
      context "when exceeding rate limit" do
        before do
          (max_requests + 10).times do |i|
            create(:registration, operator_name: "Company #{i}", company_no: "1234567#{i}")
          end
        end

        it "processes only up to the rate limit and records skips" do
          run_service

          report_content = CSV.read(report_path)
          expect(report_content.count { |row| row.last&.start_with?("SKIP:") }).to be_positive
        end
      end

      context "when handling recently updated records" do
        before do
          create(:registration, operator_name: "OLD COMPANY", company_no: "12345678")
          create(:registration, operator_name: "NEW COMPANY", company_no: "87654321")
          create(:company, name: "OLD COMPANY", company_no: "12345678", updated_at: 4.months.ago)
          create(:company, name: "NEW COMPANY", company_no: "87654321", updated_at: Time.current)
        end

        it "excludes recently updated companies from processing" do
          run_service
          report_content = CSV.read(report_path)
          expect(report_content.count { |row| row[1] == "87654321" }).to eq(0)
          expect(report_content.count { |row| row[1] == "12345678" }).to eq(1)
        end
      end

      context "when processing similar company names" do
        before do
          create(:registration, operator_name: "Acme Group Ltd", company_no: "11111111")
          create(:registration, operator_name: "ACME LIMITED GROUP", company_no: "11111111")

          allow(companies_house_api).to receive(:run)
            .with(company_number: "11111111")
            .and_return({ company_name: "ACME GROUP LIMITED",
                          registered_office_address: ["10 Downing St"] })
        end

        it "identifies and records changes meeting similarity threshold" do
          run_service
          report_content = CSV.read(report_path)
          change_rows = report_content.select { |row| row.last == "CHANGE" }

          expect(change_rows.pluck(1)).to include("11111111")
          expect(change_rows.all? { |row| row[4].to_f >= CompaniesHouseNameMatching::ProcessRegistrations::SIMILARITY_THRESHOLD }).to be true
        end
      end
    end

    context "when not in dry run mode" do
      let(:dry_run) { false }
      let(:operator_name) { "Acme Group Ltd" }
      let(:registration) do
        create(:registration, operator_name: operator_name, company_no: "11111111")
      end

      before do
        allow(companies_house_api).to receive(:run)
          .with(company_number: "11111111")
          .and_return({ company_name: "ACME GROUP LIMITED",
                        registered_office_address: ["10 Downing St"] })
        registration
      end

      it "updates operator names and records changes" do
        run_service

        expect(registration.reload.operator_name).to eq("ACME GROUP LIMITED")

        report_content = CSV.read(report_path)
        change_row = report_content.find { |row| row[1] == "11111111" && row.last == "CHANGE" }
        expect(change_row[2..3]).to eq(["Acme Group Ltd", "ACME GROUP LIMITED"])
      end

      context "when API errors occur" do
        before do
          allow(companies_house_api).to receive(:run).and_raise(StandardError.new("API Error"))
        end

        it "skips row in the report" do
          run_service

          report_content = CSV.read(report_path)
          skip_row = report_content.find { |row| row.last&.start_with?("SKIP:") }
          expect(skip_row[1..2]).to eq(["11111111", operator_name])
          expect(skip_row.last).to include("SKIP: No Companies House name found")
        end
      end
    end
  end
end
