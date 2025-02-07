# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinanceDataExportsPresenter do

  subject(:presenter) { described_class.new }

  let(:generated_report) { create(:generated_report, :finance_data, file_name: "finance_data_report.csv") }

  describe "#links" do
    before do
      generated_report
    end

    it "formats the amount in pence as pounds sterling with pound symbol" do
      expect(presenter.links.count).to eq(1)
      presenter.links.each do |link|
        expect(link[:id]).to eq(generated_report.id)
        expect(link[:text]).to eq(generated_report.file_name)
        expect(link[:url]).to include("finance_data_report.csv")
      end
    end
  end
end
