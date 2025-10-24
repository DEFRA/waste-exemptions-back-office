# frozen_string_literal: true

require "rails_helper"

RSpec.describe BoxiExportsPresenter do

  subject(:presenter) { described_class.new }

  let(:generated_report) { create(:generated_report, :boxi, file_name: "boxi_report.csv") }

  describe "#links" do
    before do
      generated_report
    end

    it "returns an array of links for each generated report" do
      expect(presenter.links.count).to eq(1)
      presenter.links.each do |link|
        expect(link[:id]).to eq(generated_report.id)
        expect(link[:text]).to eq(generated_report.file_name)
        expect(link[:url]).to include("boxi_report.csv")
      end
    end
  end

  describe "#exported_at_message" do
    context "when there are no generated reports" do
      it "returns the not yet exported message" do
        expect(presenter.exported_at_message).to eq("The file has not yet been generated")
      end
    end

    context "when there is a generated report" do
      let(:updated_at) { Time.zone.parse("2024-01-15 14:30:45") }

      before do
        create(:generated_report, :boxi, updated_at: updated_at)
      end

      it "returns the exported at message with formatted timestamp" do
        expected_message = "This file was created at 2:30pm on 15 January 2024."
        expect(presenter.exported_at_message).to eq(expected_message)
      end
    end
  end
end
