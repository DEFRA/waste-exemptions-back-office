# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe BaseRegistrationRowPresenter do
      let(:site_address) { create(:address, :site, premises: "Bar 123", area: "Wessex") }
      let(:registration) { create(:registration, addresses: [site_address]) }
      let(:presenter) { described_class.new(registration: registration) }

      before do
        registration.reference = "REG123"
      end

      describe "#registration_no" do
        it "returns the registration reference" do
          expect(presenter.registration_no).to eq("REG123")
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

      describe "#exemption" do
        it "returns nil" do
          expect(presenter.exemption).to be_nil
        end
      end

      describe "#payment_type" do
        it "returns nil" do
          expect(presenter.payment_type).to be_nil
        end
      end

      describe "#refund_type" do
        it "returns nil" do
          expect(presenter.refund_type).to be_nil
        end
      end

      describe "#reference" do
        it "returns nil" do
          expect(presenter.reference).to be_nil
        end
      end

      describe "#comments" do
        it "returns nil" do
          expect(presenter.comments).to be_nil
        end
      end

      describe "#payment_amount" do
        it "returns nil" do
          expect(presenter.payment_amount).to be_nil
        end
      end 

      describe "#on_a_farm" do
        it "returns nil" do
          expect(presenter.on_a_farm).to be_present
        end
      end

      describe "#is_a_farmer" do
        it "returns nil" do
          expect(presenter.is_a_farmer).to be_present
        end
      end

      describe "#ea_admin_area" do
        it "returns nil" do
          expect(presenter.ea_admin_area).to be_present
        end
      end

      describe "#balance" do
        it "returns nil" do
          expect(presenter.balance).to be_nil
        end
      end
    end
  end
end
