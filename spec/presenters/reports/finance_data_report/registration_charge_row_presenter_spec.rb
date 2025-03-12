# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe RegistrationChargeRowPresenter do
      let(:charge_detail) { build(:charge_detail, registration_charge_amount: 3150) }
      let(:registration) { build(:registration, reference: "REG123", submitted_at: Time.zone.now) }
      let(:presenter) { described_class.new(registration: registration, secondary_object: charge_detail, total: -1000) }

      describe "#charge_type" do
        it "returns 'registration'" do
          expect(presenter.charge_type).to eq("registration")
        end
      end

      describe "#charge_amount" do
        it "returns the formatted charge amount" do
          expect(presenter.charge_amount).to eq("31.50")
        end
      end

      describe "#balance" do
        it "returns the formatted balance amount" do
          expect(presenter.balance).to eq("-41.50")
        end
      end
    end
  end
end
