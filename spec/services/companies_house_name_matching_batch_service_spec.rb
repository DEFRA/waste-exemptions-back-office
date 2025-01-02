# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompaniesHouseNameMatchingBatchService, type: :service do
  let(:report_path) { Rails.root.join("tmp", "test_report.csv") }
  let(:summary_path) { Rails.root.join("tmp", "test_report_summary.csv") }
  let(:batch_service) { described_class.new }
  let(:similarity_threshold) { CompaniesHouseNameMatchingBatchService::SIMILARITY_THRESHOLD }
  let(:run_service) { batch_service.run(dry_run: dry_run, report_path: report_path) }
  let(:companies_house_api) { instance_double(DefraRuby::CompaniesHouse::API)}
  let(:company_name) { "COMPANY NAME"}
  let(:companies_house_api_response) do
    {
      company_name:,
      registered_office_address: ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"]
    }
  end

  let(:max_requests) { (described_class::RATE_LIMIT * described_class::RATE_LIMIT_BUFFER).to_i }

  before do
    allow(DefraRuby::CompaniesHouse::API).to receive(:new).and_return(companies_house_api)
    allow(companies_house_api).to receive(:run).and_return(companies_house_api_response)
  end

  after do
    File.delete(report_path) if File.exist?(report_path)
    File.delete(summary_path) if File.exist?(summary_path)
  end

  describe "#run" do
    shared_examples "generates a report" do
      let!(:registration) { create(:registration, operator_name: "Acme Group Ltd", company_no: "11111111") }

      it "creates a CSV report" do
        run_service
        expect(File.exist?(report_path)).to be true
      end

      it "includes headers in the report" do
        run_service
        headers = CSV.read(report_path)[3]
        expect(headers).to eq(
          ["Registration Ref", "Company Number", "Current Name",
           "Companies House Name", "Similarity Score", "Status"]
        )
      end

      it "creates a summary report" do
        run_service
        expect(File.exist?(summary_path)).to be true
      end

      it "includes a batch row with totals" do
        run_service
        summary_content = CSV.read(summary_path)

        expect(summary_content[0]).to eq([
          "Batch #",
          "Started at",
          "Completed at",
          "Processed",
          "Updated",
          "Skipped"
        ])

        expect(summary_content.size).to be >= 2
        data_row = summary_content[1]

        expect(data_row[3].to_i).to be >= 0
        expect(data_row[4].to_i).to be >= 0
        expect(data_row[5].to_i).to be >= 0
      end
    end

    context "when dry_run is true" do
      let(:dry_run) { true }

      include_examples "generates a report"

      context "when there are more companies than the rate limit allows" do
        before do
          (max_requests + 10).times do |i|
            create(:registration, operator_name: "Company #{i}", company_no: "1234567#{i}")
          end
        end

        it "processes only up to the maximum number of requests" do
          result = run_service
          expect(batch_service.instance_variable_get(:@request_count)).to eq(max_requests)
        end

        it "does not exceed the maximum number of requests" do
          run_service
          expect(batch_service.instance_variable_get(:@request_count)).to eq(max_requests)
        end

        it "records skipped companies in the report" do
          run_service
          report_content = CSV.read(report_path)
          expect(report_content.count { |row| row.last&.start_with?("SKIP:") }).to be > 0
        end
      end

      context "when there are recently updated Company records" do
        let!(:old_registration) { create(:registration, operator_name: "OLD COMPANY", company_no: "12345678") }
        let(:company_name) { "NEW COMPANY LTD" }

        before do
          create(:registration, operator_name: "NEW COMPANY", company_no: "87654321")
          create(:company, name: "OLD COMPANY", company_no: "12345678", updated_at: 4.months.ago)
          create(:company, name: "NEW COMPANY", company_no: "87654321", updated_at: Time.current)
        end

        it "will not procress that registration" do
          run_service
          report_content = CSV.read(report_path)
          expect(report_content.count { |row| row[1] == "87654321" }).to eq(0)
          expect(report_content.count { |row| row[1] == "12345678" }).to eq(1)
        end
      end

      context "when there are similar companies with various word placements" do
        let!(:group_ltd_registration) { create(:registration, operator_name: "Acme Group Ltd", company_no: "11111111") }
        let!(:limited_group_registration) { create(:registration, operator_name: "ACME LIMITED GROUP", company_no: "11111111") }
        let!(:holdings_plc_registration) { create(:registration, operator_name: "Acme Holdings Services PLC", company_no: "22222222") }
        let!(:services_group_registration) { create(:registration, operator_name: "Acme Services Holdings Group", company_no: "22222222") }

        before do
          allow(companies_house_api).to receive(:run).with(company_number: "11111111")
            .and_return(companies_house_api_response.merge(company_name: "ACME GROUP LIMITED"))
          allow(companies_house_api).to receive(:run).with(company_number: "22222222")
            .and_return(companies_house_api_response.merge(company_name: "ACME HOLDINGS SERVICES PLC"))
        end

        it "records proposed changes in the report with similarity scores" do
          run_service
          report_content = CSV.read(report_path)
          change_rows = report_content.select { |row| row.last == "CHANGE" }
          expect(change_rows.map { |row| row[1] }).to include("11111111", "22222222")
          expect(change_rows.all? { |row| row[4].to_f >= similarity_threshold }).to be true
        end
      end

      context "when there are companies with typos" do
        let!(:registration) { create(:registration, operator_name: "Pratt Developements Group Ltd", company_no: "33333333") }

        before do
          allow(companies_house_api).to receive(:run).with(company_number: "33333333")
            .and_return(companies_house_api_response.merge(company_name: "PRATT DEVELOPMENTS GROUP LIMITED"))
        end

        it "records changes with similarity scores in the report" do
          run_service
          report_content = CSV.read(report_path)
          change_row = report_content.find { |row| row[1] == "33333333" && row.last == "CHANGE" }
          expect(change_row).to be_present
          expect(change_row[4].to_f).to be >= similarity_threshold
        end
      end
    end

    context "when dry_run is false" do
      let(:dry_run) { false }
      let!(:registration) { create(:registration, operator_name: "Acme Group Ltd", company_no: "11111111") }

      include_examples "generates a report"

      before do
          allow(companies_house_api).to receive(:run).with(company_number: "11111111")
            .and_return(companies_house_api_response.merge(company_name: "ACME GROUP LIMITED"))
      end

      it "updates the operator names in the database and records the change" do
        run_service
        expect(registration.reload.operator_name).to eq("ACME GROUP LIMITED")

        report_content = CSV.read(report_path)
        change_row = report_content.find { |row| row[1] == "11111111" && row.last == "CHANGE" }
        expect(change_row).to be_present
        expect(change_row[2]).to eq("Acme Group Ltd")
        expect(change_row[3]).to eq("ACME GROUP LIMITED")
      end

      context "when an error occurs" do
        before do
          allow(companies_house_api).to receive(:run).and_raise(StandardError.new("API Error"))
        end

        it "records the error in the report" do
          run_service
          report_content = CSV.read(report_path)
          error_row = report_content.find { |row| row.last&.start_with?("ERROR:") }
          expect(error_row).to be_present
          expect(error_row[1]).to eq("11111111")
          expect(error_row.last).to include("API Error")
        end
      end
    end
  end
end
