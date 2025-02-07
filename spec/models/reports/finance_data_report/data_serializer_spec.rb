# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe DataSerializer do
      let(:account) { create(:account, :with_payment) }
      let(:order) { create(:order, :with_exemptions, :with_charge_detail, order_owner: account) }
      let(:charge_adjustment) { create(:charge_adjustment, account: account) }
      let(:site_address) { create(:address, :site, premises: "Bar 123", area: "Wessex") }
      let(:registration) { create(:registration, account: account, addresses: [site_address]) }

      let(:serializer) { described_class.new }

      shared_examples "a valid registration charge row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_no"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to eq("registration")
          expect(csv[row_number]["charge_amount"]).to be_present
          expect(csv[row_number]["charge_band"]).to be_nil
          expect(csv[row_number]["exemption"]).to be_nil
          expect(csv[row_number]["payment_type"]).to be_nil
          expect(csv[row_number]["refund_type"]).to be_nil
          expect(csv[row_number]["reference"]).to be_nil
          expect(csv[row_number]["comments"]).to be_nil
          expect(csv[row_number]["payment_amount"]).to be_nil
          expect(csv[row_number]["on_a_farm"]).to be_present
          expect(csv[row_number]["is_a_farmer"]).to be_present
          expect(csv[row_number]["ea_admin_area"]).to be_present
          expect(csv[row_number]["balance"]).to be_nil
        end
      end

      shared_examples "a valid initial compliance charge row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_no"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to eq("compliance_initial")
          expect(csv[row_number]["charge_amount"]).to be_present
          expect(csv[row_number]["charge_band"]).to be_present
          expect(csv[row_number]["exemption"]).to be_present
          expect(csv[row_number]["payment_type"]).to be_nil
          expect(csv[row_number]["refund_type"]).to be_nil
          expect(csv[row_number]["reference"]).to be_nil
          expect(csv[row_number]["comments"]).to be_nil
          expect(csv[row_number]["payment_amount"]).to be_nil
          expect(csv[row_number]["on_a_farm"]).to be_present
          expect(csv[row_number]["is_a_farmer"]).to be_present
          expect(csv[row_number]["ea_admin_area"]).to be_present
          expect(csv[row_number]["balance"]).to be_nil
        end
      end

      shared_examples "a valid additional compliance charge row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_no"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to eq("compliance_additional")
          expect(csv[row_number]["charge_amount"]).to be_present
          expect(csv[row_number]["charge_band"]).to be_present
          expect(csv[row_number]["exemption"]).to be_present
          expect(csv[row_number]["payment_type"]).to be_nil
          expect(csv[row_number]["refund_type"]).to be_nil
          expect(csv[row_number]["reference"]).to be_nil
          expect(csv[row_number]["comments"]).to be_nil
          expect(csv[row_number]["payment_amount"]).to be_nil
          expect(csv[row_number]["on_a_farm"]).to be_present
          expect(csv[row_number]["is_a_farmer"]).to be_present
          expect(csv[row_number]["ea_admin_area"]).to be_present
          expect(csv[row_number]["balance"]).to be_nil
        end
      end

      shared_examples "a valid charge adjustment row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_no"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to eq("charge_adjust")
          expect(csv[row_number]["charge_amount"]).to be_present
          expect(csv[row_number]["charge_band"]).to be_nil
          expect(csv[row_number]["exemption"]).to be_nil
          expect(csv[row_number]["payment_type"]).to be_nil
          expect(csv[row_number]["refund_type"]).to be_nil
          expect(csv[row_number]["reference"]).to be_nil
          expect(csv[row_number]["comments"]).to be_nil
          expect(csv[row_number]["payment_amount"]).to be_nil
          expect(csv[row_number]["on_a_farm"]).to be_present
          expect(csv[row_number]["is_a_farmer"]).to be_present
          expect(csv[row_number]["ea_admin_area"]).to be_present
          expect(csv[row_number]["balance"]).to be_nil
        end
      end

      shared_examples "a valid payment row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_no"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to be_nil
          expect(csv[row_number]["charge_amount"]).to be_nil
          expect(csv[row_number]["charge_band"]).to be_nil
          expect(csv[row_number]["exemption"]).to be_nil
          expect(csv[row_number]["payment_type"]).to be_present
          expect(csv[row_number]["refund_type"]).to be_nil
          expect(csv[row_number]["reference"]).to be_present
          expect(csv[row_number]["comments"]).to be_nil
          expect(csv[row_number]["payment_amount"]).to be_present
          expect(csv[row_number]["on_a_farm"]).to be_present
          expect(csv[row_number]["is_a_farmer"]).to be_present
          expect(csv[row_number]["ea_admin_area"]).to be_present
          expect(csv[row_number]["balance"]).to be_present
        end
      end

      describe "#to_csv" do
        before do
          order
          charge_adjustment
          registration
          order.charge_detail.band_charge_details.each do |band_charge_detail|
            band_charge_detail.update(band_id: order.exemptions.last.band_id)
          end
        end

        context "when CSV output is generated" do
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          it "generates correct header" do
            expect(csv.headers).to eq(%w[registration_no date charge_type charge_amount charge_band exemption 
              payment_type refund_type reference comments payment_amount on_a_farm is_a_farmer ea_admin_area balance])
          end

          it_behaves_like "a valid registration charge row", 0

          it_behaves_like "a valid initial compliance charge row", 1
          it_behaves_like "a valid additional compliance charge row", 2

          it_behaves_like "a valid initial compliance charge row", 3
          it_behaves_like "a valid additional compliance charge row", 4

          it_behaves_like "a valid initial compliance charge row", 5
          it_behaves_like "a valid additional compliance charge row", 6

          it_behaves_like "a valid charge adjustment row", 7
          it_behaves_like "a valid payment row", 8
        end
      end
    end
  end
end
