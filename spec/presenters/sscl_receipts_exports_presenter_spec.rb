# frozen_string_literal: true

require "rails_helper"

RSpec.describe SsclReceiptsExportsPresenter do
  subject(:presenter) { described_class.new }

  describe "#links" do
    let(:generated_report) { create(:generated_report, :sscl_receipts, file_name: "sscl_receipts.csv") }

    before do
      generated_report
    end

    it "returns an array of links for each generated report" do
      link = presenter.links.first

      expect(link[:id]).to eq(generated_report.id)
      expect(link[:text]).to eq(generated_report.file_name)
      expect(link[:url]).to include("sscl_receipts.csv")
    end
  end

  describe "#exported_at_message" do
    context "when there are no generated reports" do
      it "returns the not yet exported message" do
        expect(presenter.exported_at_message).to eq("The file has not yet been generated")
      end
    end

    context "when there is a generated report" do
      let(:created_at) { Time.zone.local(2026, 5, 26, 10, 30) }

      before do
        create(:generated_report, :sscl_receipts, created_at: created_at)
      end

      it "returns a message with the most recent export time" do
        expect(presenter.exported_at_message).to eq("The most recent file was created at 10:30am on 26 May 2026.")
      end
    end
  end
end
