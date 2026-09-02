# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::RegistrationNonPaymentsExportService do
  subject(:csv) { CSV.parse(described_class.run) }

  def registration_owing(owed, submitted_at:, operator_name:)
    registration = create(:registration,
                          registration_exemptions: build_list(:registration_exemption, 1, :active),
                          operator_name: operator_name,
                          submitted_at: submitted_at)
    registration.account.orders << create(:order,
                                          charge_detail: build(:charge_detail,
                                                               registration_charge_amount: owed,
                                                               band_charge_details: []))
    registration
  end

  let!(:severn_trent) do
    registration_owing(74_650, submitted_at: 58.days.ago.to_date, operator_name: "Severn Trent")
  end
  let!(:anna_kay_williams) do
    registration_owing(8_800, submitted_at: 70.days.ago.to_date, operator_name: "Anna-Kay Williams")
  end

  before { registration_owing(499, submitted_at: 90.days.ago.to_date, operator_name: "Under the threshold") }

  describe ".run" do
    it "starts with a header row" do
      expect(csv.first).to eq(["WEX number", "Organisation name", "Amount owed", "Days since registration"])
    end

    it "lists the registrations owing money, longest since registration first" do
      expect(csv.drop(1)).to eq(
        [
          [anna_kay_williams.reference, "Anna-Kay Williams", "88.00", "70"],
          [severn_trent.reference, "Severn Trent", "746.50", "58"]
        ]
      )
    end
  end
end
