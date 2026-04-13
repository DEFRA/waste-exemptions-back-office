# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaymentDetails::ChargeBreakdownPresenter do
  subject(:presenter) { described_class.new(order:, is_multisite:) }

  let(:rows) { presenter.rows }
  let(:is_multisite) { false }
  let(:bucket_band) { create(:band) }
  let(:chargeable_band) { create(:band) }
  let(:no_charge_band) { create(:band) }
  let(:bucket_exemption) { create(:exemption, code: "EX001", band: bucket_band) }
  let(:chargeable_exemption) { create(:exemption, code: "EX002", band: chargeable_band) }
  let(:no_charge_exemption) { create(:exemption, code: "EX003", band: no_charge_band) }
  let(:bucket) { build(:bucket, :farmer_exemptions, exemptions: [bucket_exemption]) }
  let(:charge_detail) do
    build(
      :charge_detail,
      registration_charge_amount: 1500,
      bucket_charge_amount: 1000,
      site_count: 3,
      band_charge_details: [
        build(
          :band_charge_detail,
          band: chargeable_band,
          initial_compliance_charge_amount: 2500,
          additional_compliance_charge_amount: 0
        ),
        build(
          :band_charge_detail,
          band: no_charge_band,
          initial_compliance_charge_amount: 0,
          additional_compliance_charge_amount: 0
        )
      ]
    )
  end
  let(:order) do
    build(
      :order,
      exemptions: [bucket_exemption, chargeable_exemption, no_charge_exemption],
      bucket:,
      charge_detail:
    )
  end

  describe "#date" do
    it "returns the order date" do
      expect(presenter.date).to eq(order.created_at)
    end
  end

  describe "#rows" do
    it "builds the expected rows for a single-site order" do
      expect(rows.map { |row| [row.label, row.amount_pence] }).to eq(
        [
          ["EX002", 2500],
          ["EX003", 0],
          ["Farming exemptions EX001", 1000],
          ["Registration charge", 1500],
          ["Total charge", 5000]
        ]
      )
    end

    it "exposes presentational cell classes on each row" do
      expect(rows.first.breakdown_cell_classes).to eq("govuk-!-padding-top-2")
      expect(rows.first.amount_cell_classes).to eq("govuk-!-text-align-right govuk-!-padding-top-2")
      expect(rows.last.breakdown_cell_classes).to eq("govuk-table__cell govuk-!-padding-top-0")
      expect(rows.last.amount_cell_classes).to eq("govuk-table__cell govuk-!-text-align-right govuk-!-padding-top-0")
    end
  end

  describe "#rowspan" do
    it "matches the number of rendered rows" do
      expect(presenter.rowspan).to eq(5)
    end
  end

  context "when rendering a multisite charge breakdown" do
    let(:is_multisite) { true }

    it "adds the site count suffix to exemption rows" do
      expect(rows.map(&:label)).to eq(
        [
          "EX002 x [3]",
          "EX003 x [3]",
          "Farming exemptions EX001 x [3]",
          "Registration charge",
          "Total charge"
        ]
      )
    end
  end
end
