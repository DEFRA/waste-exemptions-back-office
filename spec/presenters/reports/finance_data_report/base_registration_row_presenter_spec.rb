# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe BaseRegistrationRowPresenter do
      let(:registration) { build(:registration, reference: "REG123") }
      let(:presenter) { described_class.new(registration: registration) }

      describe "#registration_number" do
        it "returns the registration reference" do
          expect(presenter.registration_number).to eq("REG123")
        end
      end

      describe "#date" do
        it "returns the formatted submitted_at date" do
          formatted_date = registration.submitted_at.to_fs(:day_month_year_slashes)
          expect(presenter.date).to eq(formatted_date)
        end
      end

      describe "#charge_type" do
        it "returns nil" do
          expect(presenter.charge_type).to be_nil
        end
      end

      describe "#charge_amount" do
        it "returns nil" do
          expect(presenter.charge_amount).to be_nil
        end
      end

      describe "#charge_band" do
        it "returns nil" do
          expect(presenter.charge_band).to be_nil
        end
      end
    end
  end
end
