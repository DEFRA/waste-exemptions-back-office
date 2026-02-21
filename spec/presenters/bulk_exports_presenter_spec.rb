# frozen_string_literal: true

require "rails_helper"

RSpec.describe BulkExportsPresenter do

  subject(:presenter) { described_class.new }

  let(:generated_report) do
    create(:generated_report, :bulk, file_name: "20230601-20230630.csv",
                                     data_from_date: Date.new(2023, 6, 1))
  end

  describe "#links" do
    before do
      generated_report
    end

    it "returns an array of links for each generated report" do
      expect(presenter.links.count).to eq(1)
      presenter.links.each do |link|
        expect(link[:id]).to eq(generated_report.id)
        expect(link[:text]).to eq("June 2023")
        expect(link[:url]).to include("20230601-20230630.csv")
      end
    end
  end

  describe "#exported_at_message" do
    context "when there are no generated reports" do
      it "returns the not yet exported message" do
        expect(presenter.exported_at_message).to eq("The files have not yet been generated")
      end
    end

    context "when there is a generated report" do
      let(:created_at) { Time.zone.parse("2024-01-15 14:30:45") }

      before do
        create(:generated_report, :bulk, created_at: created_at,
                                         data_from_date: Date.new(2024, 1, 1))
      end

      it "returns the exported at message with formatted timestamp" do
        expected_message = "These files were created at 2:30pm on 15 January 2024."
        expect(presenter.exported_at_message).to eq(expected_message)
      end
    end
  end
end
