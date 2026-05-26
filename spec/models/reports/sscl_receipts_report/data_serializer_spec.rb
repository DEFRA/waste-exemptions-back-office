# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::SsclReceiptsReport::DataSerializer do
  subject(:csv) { CSV.parse(serializer.to_csv, headers: true) }

  let(:serializer) { described_class.new }
  let(:registration) do
    create(
      :registration,
      submitted_at: Date.new(2025, 2, 3)
    )
  end
  let!(:payment) do
    create(
      :payment,
      :bank_transfer,
      account: registration.account,
      date_time: Time.zone.local(2025, 2, 4, 10, 30),
      created_at: Time.zone.local(2025, 2, 5, 11, 45)
    )
  end

  describe "#to_csv" do
    it "generates the requested headers" do
      expect(csv.headers).to eq([
                                  "WEX Reg number",
                                  "Date of reg",
                                  "Date of payment",
                                  "Date payment added to registration",
                                  "Payment type"
                                ])
    end

    it "exports payment receipt details" do
      row = csv.first

      aggregate_failures do
        expect(row["WEX Reg number"]).to eq(registration.reference)
        expect(row["Date of reg"]).to eq("03/02/2025")
        expect(row["Date of payment"]).to eq("04/02/2025")
        expect(row["Date payment added to registration"]).to eq("05/02/2025")
        expect(row["Payment type"]).to eq("BACS")
      end
    end

    it "only includes successful receipt payments since charging started" do
      another_registration = create(:registration, submitted_at: Date.new(2025, 2, 3))

      create(
        :payment,
        :bank_transfer,
        account: another_registration.account,
        date_time: Time.zone.local(2025, 1, 31, 12)
      )
      create(
        :payment,
        account: another_registration.account,
        payment_status: "failed",
        date_time: Time.zone.local(2025, 2, 4, 12)
      )
      create(
        :payment,
        :refund,
        account: another_registration.account,
        date_time: Time.zone.local(2025, 2, 4, 12)
      )
      create(
        :payment,
        :reversal,
        account: another_registration.account,
        date_time: Time.zone.local(2025, 2, 4, 12)
      )

      expect(csv.pluck("WEX Reg number")).to contain_exactly(registration.reference)
    end
  end
end
