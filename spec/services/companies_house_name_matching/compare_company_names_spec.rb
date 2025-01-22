# frozen_string_literal: true

require "rails_helper"
RSpec.describe CompaniesHouseNameMatching::CompareCompanyNames do
  subject(:service) { described_class.new(companies_house_name) }

  let(:companies_house_name) { "SEVERN TRENT PLC" }

  describe "#run" do
    context "when names are identical" do
      it "returns a similarity of 1.0" do
        expect(described_class.run(companies_house_name:, other_company_name: "SEVERN TRENT PLC")).to eq(1.0)
      end
    end

    context "when names differ only in case" do
      it "returns a similarity of 1.0" do
        expect(described_class.run(companies_house_name:, other_company_name: "severn trent plc")).to eq(1.0)
      end
    end

    context "when names have connector variations" do
      let(:companies_house_name) { "SMITH & SONS LIMITED" }

      it "treats '&' and 'and' as equivalent" do
        expect(described_class.run(companies_house_name:, other_company_name: "SMITH AND SONS LIMITED")).to eq(1.0)
      end

      it "treats names without connectors as equivalent" do
        expect(described_class.run(companies_house_name:, other_company_name: "SMITH SONS LIMITED")).to eq(1.0)
      end
    end

    context "when names have punctuation differences" do
      it "returns high similarity despite punctuation" do
        expect(described_class.run(companies_house_name:, other_company_name: "SEVERN TRENT, PLC")).to eq(1.0)
      end
    end

    context "when names have typos" do
      it "returns lower but significant similarity" do
        similarity = described_class.run(companies_house_name:, other_company_name: "SEVENR TRENT PLC")
        expect(similarity).to be >= 0.7
        expect(similarity).to be < 1.0
      end
    end

    context "when names are completely different" do
      it "returns low similarity" do
        expect(described_class.run(companies_house_name:, other_company_name: "TOTALLY DIFFERENT COMPANY LTD")).to be < 0.5
      end
    end

    context "when handling various company suffixes" do
      let(:companies_house_name) { "SMITH & SONS LIMITED" }

      CompaniesHouseNameMatching::CompareCompanyNames::COMMON_WORDS.each do |suffix|
        it "ignores common suffixes like '#{suffix}'" do
          expect(described_class.run(companies_house_name:, other_company_name: "SMITH & SONS #{suffix}")).to eq(1.0)
        end
      end
    end

    context "when dealing with whitespace variations" do
      let(:companies_house_name) { "SEVERN       TRENT      PLC" }

      it "normalizes whitespace differences" do
        expect(described_class.run(companies_house_name:, other_company_name: "SEVERN TRENT PLC")).to eq(1.0)
      end
    end

    context "with edge cases" do
      context "when comparing with empty string" do
        it "returns zero similarity" do
          expect(described_class.run(companies_house_name:, other_company_name: "")).to eq(0.0)
        end
      end

      context "when comparing with nil" do
        it "returns zero similarity" do
          expect(described_class.run(companies_house_name:, other_company_name: nil)).to eq(0.0)
        end
      end
    end
  end
end
