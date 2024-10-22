# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompaniesHouseNameMatchingService, type: :service do
  let(:run_service) { described_class.run(dry_run: dry_run) }
  let(:max_requests) { (CompaniesHouseNameMatchingService::RATE_LIMIT * CompaniesHouseNameMatchingService::RATE_LIMIT_BUFFER).to_i }

  describe "#run" do
    context "when dry_run is true" do
      let(:dry_run) { true }

      context "when there are more companies than the rate limit allows" do
        before do
          (max_requests + 10).times do |i|
            create(:registration, operator_name: "Company #{i}", company_no: i.to_s.rjust(8, "0"))
          end
          allow(DefraRubyCompaniesHouse).to receive(:new).and_return(
            instance_double(DefraRubyCompaniesHouse, company_name: "COMPANY NAME")
          )
        end

        it "processes only up to the maximum number of requests" do
          result = run_service
          expect(result.size).to be <= max_requests
        end

        it "does not exceed the maximum number of requests" do
          service = described_class.new
          service.run(dry_run: dry_run)
          expect(service.instance_variable_get(:@request_count)).to eq(max_requests)
        end
      end

      context "when there are recently updated Company records" do
        before do
          create(:registration, operator_name: "OLD COMPANY", company_no: "12345678")
          create(:registration, operator_name: "NEW COMPANY", company_no: "87654321")
          create(:company, name: "OLD COMPANY", company_no: "12345678", updated_at: 4.months.ago)
          create(:company, name: "NEW COMPANY", company_no: "87654321", updated_at: Time.current)
          allow(DefraRubyCompaniesHouse).to receive(:new).and_return(
            instance_double(DefraRubyCompaniesHouse, company_name: "NEW COMPANY LTD")
          )
        end

        it "only processes companies without recent updates to their company record" do
          result = run_service
          expect(result.keys).to contain_exactly("12345678")
        end

        it "does not update the Company record" do
          run_service
          expect(WasteExemptionsEngine::Company.find_by(company_no: "12345678").name).to eq("OLD COMPANY")
        end

        it "does not update the updated_at timestamp of the Company record" do
          company = WasteExemptionsEngine::Company.find_by(company_no: "12345678")
          run_service
          expect(company.reload.updated_at).to be_within(1.second).of(4.months.ago)
        end

      end

      context "when there are similar companies with various word placements" do
        before do
          create(:registration, operator_name: "Acme Group Ltd", company_no: "11111111")
          create(:registration, operator_name: "ACME LIMITED GROUP", company_no: "11111111")
          create(:registration, operator_name: "Acme Holdings Services PLC", company_no: "22222222")
          create(:registration, operator_name: "Acme Services Holdings Group", company_no: "22222222")
          allow(DefraRubyCompaniesHouse).to receive(:new).with("11111111").and_return(
            instance_double(DefraRubyCompaniesHouse, company_name: "ACME GROUP LIMITED")
          )
          allow(DefraRubyCompaniesHouse).to receive(:new).with("22222222").and_return(
            instance_double(DefraRubyCompaniesHouse, company_name: "ACME HOLDINGS SERVICES PLC")
          )
        end

        it "proposes changes for similar companies" do
          result = run_service
          expect(result.keys).to contain_exactly("11111111", "22222222")
          expect(result["11111111"].size).to eq(2)
          expect(result["22222222"].size).to eq(2)
        end

        it "proposes changes for all variations of the company name" do
          result = run_service
          expect(result["11111111"].pluck(1)).to include("Acme Group Ltd", "ACME LIMITED GROUP")
          expect(result["22222222"].pluck(1)).to include("Acme Holdings Services PLC", "Acme Services Holdings Group")
        end
      end

      context "when there are companies with typos" do
        before do
          create(:registration, operator_name: "Pratt Developements Group Ltd", company_no: "33333333")
          allow(DefraRubyCompaniesHouse).to receive(:new).with("33333333").and_return(
            instance_double(DefraRubyCompaniesHouse, company_name: "PRATT DEVELOPMENTS GROUP LIMITED")
          )
        end

        it "proposes changes for companies with typos" do
          result = run_service
          expect(result.keys).to include("33333333")
          expect(result["33333333"].first[1]).to eq("Pratt Developements Group Ltd")
          expect(result["33333333"].first[2]).to eq("PRATT DEVELOPMENTS GROUP LIMITED")
        end
      end

      context "when the company name is already correct" do
        before do
          create(:registration, operator_name: "ACME GROUP LIMITED", company_no: "11111111")
          allow(DefraRubyCompaniesHouse).to receive(:new).with("11111111").and_return(
            instance_double(DefraRubyCompaniesHouse, company_name: "ACME GROUP LIMITED")
          )
        end

        it "does not propose any changes" do
          result = run_service
          expect(result).to be_empty
        end
      end
    end

    context "when dry_run is false" do
      let(:dry_run) { false }

      before do
        create(:registration, operator_name: "Acme Group Ltd", company_no: "11111111")
        allow(DefraRubyCompaniesHouse).to receive(:new).with("11111111").and_return(
          instance_double(DefraRubyCompaniesHouse, company_name: "ACME GROUP LIMITED")
        )
      end

      it "updates the operator names in the database" do
        run_service
        expect(WasteExemptionsEngine::Registration.find_by(company_no: "11111111").operator_name).to eq("ACME GROUP LIMITED")
      end

      it "creates a Company record for the processed company" do
        expect { run_service }.to change(WasteExemptionsEngine::Company, :count).by(1)
      end

      it "updates the Company record with the correct name" do
        run_service
        expect(WasteExemptionsEngine::Company.find_by(company_no: "11111111").name).to eq("ACME GROUP LIMITED")
      end

      it "updates the updated_at timestamp of the Company record" do
        company = create(:company, company_no: "11111111", updated_at: 4.months.ago)
        run_service
        expect(company.reload.updated_at).to be_within(1.second).of(Time.current)
      end

      context "when there are recently updated Company records" do
        before do
          create(:registration, operator_name: "Old Company", company_no: "12345678")
          create(:registration, operator_name: "New Company", company_no: "87654321")
          create(:company, name: "OLD COMPANY", company_no: "12345678", updated_at: 4.months.ago)
          create(:company, name: "NEW COMPANY", company_no: "87654321", updated_at: Time.current)
          allow(DefraRubyCompaniesHouse).to receive(:new).and_return(
            instance_double(DefraRubyCompaniesHouse, company_name: "NEW COMPANY LTD")
          )
        end

        it "only processes companies without recent updates to their company record" do
          result = run_service
          expect(result.keys).to contain_exactly("12345678")
        end
      end

      context "when no companies house name is found" do
        before do
          allow(DefraRubyCompaniesHouse).to receive(:new).and_return(
            instance_double(DefraRubyCompaniesHouse, company_name: "")
          )
        end

        it "does not propose any changes" do
          result = run_service
          expect(result).to be_empty
        end

        it "still creates a Company record" do
          expect { run_service }.to change(WasteExemptionsEngine::Company, :count).by(1)
        end

        it "creates a Company record with the name 'Not found'" do
          run_service
          expect(WasteExemptionsEngine::Company.find_by(company_no: "11111111").name).to eq("Not found")
        end
      end
    end
  end
end
