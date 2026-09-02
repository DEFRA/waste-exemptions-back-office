# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationNonPaymentsService do
  subject(:non_payments) { described_class.run }

  # Builds a registration whose account is short by `owed` pence.
  def registration_owing(owed, submitted_at: Time.zone.today, active: true)
    exemptions = build_list(:registration_exemption, 1, active ? :active : :ceased)
    registration = create(:registration, registration_exemptions: exemptions, submitted_at: submitted_at)
    registration.account.orders << create(:order, charge_detail: charge_detail_for(owed))
    registration
  end

  # ChargeDetail recalculates its total on save, so the amount owed has to be
  # driven by the registration charge rather than set directly.
  def charge_detail_for(owed)
    build(:charge_detail, registration_charge_amount: owed, band_charge_details: [])
  end

  describe ".run" do
    it "includes an active registration owing more than the minimum" do
      registration = registration_owing(8_800)

      expect(non_payments).to contain_exactly(registration)
      expect(non_payments.first.amount_owed).to eq(8_800)
    end

    it "excludes a registration owing less than the minimum" do
      registration_owing(499)

      expect(non_payments).to be_empty
    end

    it "includes a registration owing exactly the minimum" do
      registration = registration_owing(described_class::MINIMUM_AMOUNT_OWED_IN_PENCE)

      expect(non_payments).to contain_exactly(registration)
    end

    it "excludes a registration which is not active" do
      registration_owing(8_800, active: false)

      expect(non_payments).to be_empty
    end

    it "excludes a registration with no account" do
      create(:registration, :with_active_exemptions, account: nil)

      expect(non_payments).to be_empty
    end

    it "excludes a fully paid registration" do
      registration = registration_owing(8_800)
      create(:payment, :success, account: registration.account, payment_amount: 8_800)

      expect(non_payments).to be_empty
    end

    it "ignores payments which did not succeed" do
      registration = registration_owing(8_800)
      create(:payment, account: registration.account, payment_status: "failed", payment_amount: 8_800)

      expect(non_payments).to contain_exactly(registration)
    end

    it "adds charge increases to the amount owed" do
      registration = registration_owing(400)
      create(:charge_adjustment, account: registration.account, adjustment_type: "increase", amount: 200)

      expect(non_payments.first.amount_owed).to eq(600)
    end

    it "subtracts charge decreases from the amount owed" do
      registration_owing(600)
      create(:charge_adjustment, account: WasteExemptionsEngine::Account.last,
                                 adjustment_type: "decrease", amount: 200)

      expect(non_payments).to be_empty
    end

    it "matches the balance calculated for a single account" do
      registration = registration_owing(8_800)
      create(:payment, :success, account: registration.account, payment_amount: 1_000)
      create(:charge_adjustment, account: registration.account, adjustment_type: "increase", amount: 500)

      expect(non_payments.first.amount_owed).to eq(-registration.account.reload.balance)
    end

    it "orders by days since registration, longest first" do
      recent = registration_owing(8_800, submitted_at: 10.days.ago.to_date)
      oldest = registration_owing(8_800, submitted_at: 70.days.ago.to_date)
      middle = registration_owing(8_800, submitted_at: 30.days.ago.to_date)

      expect(non_payments.to_a).to eq([oldest, middle, recent])
    end
  end
end
