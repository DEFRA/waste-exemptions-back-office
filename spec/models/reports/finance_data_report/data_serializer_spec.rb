# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe DataSerializer do
      let(:account) { create(:account, :with_payment) }
      let(:order) { create(:order, :with_exemptions, :with_charge_detail, order_owner: account) }
      let(:charge_adjustment) { create(:charge_adjustment, account: account) }
      let(:site_address) { create(:address, :site_address, premises: "Bar 123", area: "Wessex") }
      let(:registration) { create(:registration, account: account, addresses: [site_address]) }

      let(:serializer) { described_class.new }

      shared_examples "a valid row with common fields" do |row_number|
        it "has common fields populated correctly" do
          aggregate_failures do
            expect(csv[row_number]["registration_no"]).to eq(registration.reference)
            expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
            expect(csv[row_number]["multisite"]).to be_present
            expect(csv[row_number]["organisation_name"]).to be_present
            expect(csv[row_number]["on_a_farm"]).to be_present
            expect(csv[row_number]["is_a_farmer"]).to be_present
            expect(csv[row_number]["ea_admin_area"]).to be_present
            expect(csv[row_number]["balance"]).to be_present
            expect(csv[row_number]["status"]).to be_present
          end
        end
      end

      shared_examples "a valid registration charge row" do |row_number|
        it_behaves_like "a valid row with common fields", row_number

        it "has registration charge specific fields" do
          aggregate_failures do
            expect(csv[row_number]["site"]).to be_nil
            expect(csv[row_number]["charge_type"]).to eq("registration")
            expect(csv[row_number]["charge_amount"]).to be_present
            expect(csv[row_number]["charge_band"]).to be_nil
            expect(csv[row_number]["exemption"]).to be_nil
            expect(csv[row_number]["payment_type"]).to be_nil
            expect(csv[row_number]["refund_type"]).to be_nil
            expect(csv[row_number]["reference"]).to be_nil
            expect(csv[row_number]["comments"]).to be_nil
            expect(csv[row_number]["payment_amount"]).to be_nil
            expect(csv[row_number]["payment_status"]).to be_nil
          end
        end
      end

      shared_examples "a valid initial compliance charge row" do |row_number|
        it_behaves_like "a valid row with common fields", row_number

        it "has initial compliance charge specific fields" do
          aggregate_failures do
            expect(csv[row_number]["charge_type"]).to eq("compliance_initial")
            expect(csv[row_number]["charge_amount"]).to be_present
            expect(csv[row_number]["charge_band"]).to be_present
            expect(csv[row_number]["exemption"]).to be_present
            expect(csv[row_number]["payment_type"]).to be_nil
            expect(csv[row_number]["refund_type"]).to be_nil
            expect(csv[row_number]["reference"]).to be_nil
            expect(csv[row_number]["comments"]).to be_nil
            expect(csv[row_number]["payment_amount"]).to be_nil
            expect(csv[row_number]["payment_status"]).to be_nil
          end
        end
      end

      shared_examples "a valid additional compliance charge row" do |row_number|
        it_behaves_like "a valid row with common fields", row_number

        it "has additional compliance charge specific fields" do
          aggregate_failures do
            expect(csv[row_number]["charge_type"]).to eq("compliance_additional")
            expect(csv[row_number]["charge_amount"]).to be_present
            expect(csv[row_number]["charge_band"]).to be_present
            expect(csv[row_number]["exemption"]).to be_present
            expect(csv[row_number]["payment_type"]).to be_nil
            expect(csv[row_number]["refund_type"]).to be_nil
            expect(csv[row_number]["reference"]).to be_nil
            expect(csv[row_number]["comments"]).to be_nil
            expect(csv[row_number]["payment_amount"]).to be_nil
            expect(csv[row_number]["payment_status"]).to be_nil
          end
        end
      end

      shared_examples "a valid farm compliance charge row" do |row_number|
        it_behaves_like "a valid row with common fields", row_number

        it "has farm compliance charge specific fields" do
          aggregate_failures do
            expect(csv[row_number]["charge_type"]).to eq("compliance_farm")
            expect(csv[row_number]["charge_amount"]).to be_present
            expect(csv[row_number]["charge_band"]).to be_nil
            expect(csv[row_number]["exemption"]).to be_present
            expect(csv[row_number]["payment_type"]).to be_nil
            expect(csv[row_number]["refund_type"]).to be_nil
            expect(csv[row_number]["reference"]).to be_nil
            expect(csv[row_number]["comments"]).to be_nil
            expect(csv[row_number]["payment_amount"]).to be_nil
            expect(csv[row_number]["on_a_farm"]).to be_truthy
            expect(csv[row_number]["is_a_farmer"]).to be_truthy
            expect(csv[row_number]["payment_status"]).to be_nil
          end
        end
      end

      shared_examples "a valid charge adjustment row" do |row_number|
        it_behaves_like "a valid row with common fields", row_number

        it "has charge adjustment specific fields" do
          aggregate_failures do
            expect(csv[row_number]["charge_type"]).to eq("charge_adjust")
            expect(csv[row_number]["charge_amount"]).to be_present
            expect(csv[row_number]["charge_band"]).to be_nil
            expect(csv[row_number]["exemption"]).to be_nil
            expect(csv[row_number]["payment_type"]).to be_nil
            expect(csv[row_number]["refund_type"]).to be_nil
            expect(csv[row_number]["reference"]).to be_nil
            expect(csv[row_number]["comments"]).to be_present
            expect(csv[row_number]["payment_amount"]).to be_nil
            expect(csv[row_number]["payment_status"]).to be_nil
          end
        end
      end

      shared_examples "a valid payment row" do |row_number|
        it_behaves_like "a valid row with common fields", row_number

        it "has payment specific fields" do
          aggregate_failures do
            expect(csv[row_number]["charge_type"]).to be_nil
            expect(csv[row_number]["charge_amount"]).to be_nil
            expect(csv[row_number]["charge_band"]).to be_nil
            expect(csv[row_number]["exemption"]).to be_nil
            expect(csv[row_number]["payment_type"]).to be_present
            expect(csv[row_number]["refund_type"]).to be_nil
            expect(csv[row_number]["reference"]).to be_present
            expect(csv[row_number]["comments"]).to be_nil
            expect(csv[row_number]["payment_amount"]).to be_present
            expect(csv[row_number]["payment_status"]).to be_nil
          end
        end
      end

      shared_examples "a valid summary row" do |row_number|
        it "has summary row specific fields" do
          aggregate_failures do
            expect(csv[row_number]["registration_no"]).to eq(registration.reference)
            expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
            expect(csv[row_number]["multisite"]).to be_present
            expect(csv[row_number]["organisation_name"]).to be_present
            expect(csv[row_number]["site"]).to be_nil
            expect(csv[row_number]["charge_type"]).to eq("summary")
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
            expect(csv[row_number]["balance"]).to be_present
            expect(csv[row_number]["payment_status"]).to be_present
            expect(csv[row_number]["status"]).to be_present
          end
        end
      end

      describe "#to_csv" do
        context "when CSV output is generated - registration has single order" do
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          before do
            order
            charge_adjustment
            registration
            order.charge_detail.band_charge_details.each do |band_charge_detail|
              band_charge_detail.update(band_id: order.exemptions.last.band_id)
            end
          end

          it "generates correct header" do
            expect(csv.headers).to eq(%w[registration_no date multisite organisation_name site charge_type charge_amount charge_band exemption
                                         payment_type refund_type reference comments payment_amount on_a_farm is_a_farmer ea_admin_area balance payment_status status])
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
          it_behaves_like "a valid summary row", 9

          it "only includes payment_status on the summary row" do
            summary_rows = csv.select { |row| row["charge_type"] == "summary" }
            non_summary_rows = csv.reject { |row| row["charge_type"] == "summary" }

            expect(summary_rows).not_to be_empty
            expect(summary_rows.map { |row| row["payment_status"] }).to all(be_present)
            expect(non_summary_rows.map { |row| row["payment_status"] }).to all(be_nil)
          end

          it "keeps the final balance unchanged on the summary row" do
            expect(csv[9]["balance"]).to eq(csv[8]["balance"])
          end

          it "shows summary charge_amount as the total of charge rows" do
            summary_charge_amount_in_pence = (csv[9]["charge_amount"].to_r * 100).to_i

            charge_rows_total_in_pence = csv.reject do |row|
              row["charge_type"].blank? || row["charge_type"] == "summary"
            end.sum do |row|
              (row["charge_amount"].to_r * 100).to_i
            end

            expect(summary_charge_amount_in_pence).to eq(charge_rows_total_in_pence)
          end
        end

        context "when CSV output is generated - when registration has multiple orders" do
          let(:order2) { create(:order, :with_exemptions, :with_charge_detail, order_owner: account) }
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          before do
            order
            charge_adjustment
            registration
            order.charge_detail.band_charge_details.each do |band_charge_detail|
              band_charge_detail.update(band_id: order.exemptions.last.band_id)
            end
            order2
            charge_adjustment
            registration
            order2.charge_detail.band_charge_details.each do |band_charge_detail2|
              band_charge_detail2.update(band_id: order2.exemptions.last.band_id)
            end
          end

          it "generates correct header" do
            expect(csv.headers).to eq(%w[registration_no date multisite organisation_name site charge_type charge_amount charge_band exemption
                                         payment_type refund_type reference comments payment_amount on_a_farm is_a_farmer ea_admin_area balance payment_status status])
          end

          # ORDER 1

          it_behaves_like "a valid registration charge row", 0

          it_behaves_like "a valid initial compliance charge row", 1
          it_behaves_like "a valid additional compliance charge row", 2

          it_behaves_like "a valid initial compliance charge row", 3
          it_behaves_like "a valid additional compliance charge row", 4

          it_behaves_like "a valid initial compliance charge row", 5
          it_behaves_like "a valid additional compliance charge row", 6

          it_behaves_like "a valid charge adjustment row", 7
          it_behaves_like "a valid payment row", 8
          it_behaves_like "a valid summary row", 9

          # ORDER 2

          it_behaves_like "a valid registration charge row", 10

          it_behaves_like "a valid initial compliance charge row", 11
          it_behaves_like "a valid additional compliance charge row", 12

          it_behaves_like "a valid initial compliance charge row", 13
          it_behaves_like "a valid additional compliance charge row", 14

          it_behaves_like "a valid initial compliance charge row", 15
          it_behaves_like "a valid additional compliance charge row", 16

          it_behaves_like "a valid charge adjustment row", 17
          it_behaves_like "a valid payment row", 18
          it_behaves_like "a valid summary row", 19
        end

        context "when CSV output is generated - registration has both successful and failed payments" do
          let(:account) { create(:account) }
          let(:order) { create(:order, :with_exemptions, :with_charge_detail, order_owner: account) }
          let(:successful_payment) { create(:payment, account: account, payment_status: "success") }
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          before do
            order
            registration
            # Explicitly create payments with different statuses
            successful_payment
            create(:payment, account: account, payment_status: "failed")
            create(:payment, account: account, payment_status: "cancelled")
            create(:payment, account: account, payment_status: "error")
          end

          it "only includes successful payments in the export" do
            payment_rows = csv.select { |row| row["payment_type"].present? }

            expect(payment_rows.count).to eq(1)

            expect(payment_rows.first["reference"]).to eq(successful_payment.reference)
          end
        end

        context "when CSV output is generated - registration has farmer exemptions" do
          let(:bucket) { create(:bucket, :farmer_exemptions) }
          let(:order) { create(:order, :with_exemptions, :with_charge_detail, order_owner: account, bucket: bucket) }
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          before do
            order
            charge_adjustment
            registration
            order.charge_detail.band_charge_details.each do |band_charge_detail|
              band_charge_detail.update(band_id: order.exemptions.last.band_id)
            end
            bucket.exemptions << order.exemptions.last
            order.charge_detail.update(bucket_charge_amount: 8850)
          end

          it "generates correct header" do
            expect(csv.headers).to eq(%w[registration_no date multisite organisation_name site charge_type charge_amount charge_band exemption
                                         payment_type refund_type reference comments payment_amount on_a_farm is_a_farmer ea_admin_area balance payment_status status])
          end

          it_behaves_like "a valid registration charge row", 0

          it_behaves_like "a valid initial compliance charge row", 1
          it_behaves_like "a valid additional compliance charge row", 2

          it_behaves_like "a valid initial compliance charge row", 3
          it_behaves_like "a valid additional compliance charge row", 4

          it_behaves_like "a valid initial compliance charge row", 5
          it_behaves_like "a valid additional compliance charge row", 6
          it_behaves_like "a valid farm compliance charge row", 7

          it_behaves_like "a valid charge adjustment row", 8
          it_behaves_like "a valid payment row", 9
          it_behaves_like "a valid summary row", 10
        end

        context "when registration is multisite" do
          let(:multisite_registration) { create(:registration, :multisite_complete, account: account) }
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          before do
            order.update(order_owner: multisite_registration.account)
            multisite_registration.site_addresses.first.update(area: "Wessex")
            multisite_registration.site_addresses.second.update(area: "Yorkshire")

            multisite_registration.site_addresses.each do |_site_address|
              order.exemptions.each { |exemption| create(:registration_exemption, registration: multisite_registration, exemption: exemption) }
            end

            order.charge_detail.band_charge_details.first.update(band_id: order.exemptions.first.band_id)
          end

          it "includes multisite flag as TRUE for multisite registrations" do
            multisite_rows = csv.select { |row| row["registration_no"]&.include?(multisite_registration.reference) }

            multisite_rows.each do |row|
              expect(row["multisite"]).to eq("TRUE")
            end
          end

          it "generates compliance rows with site suffix for multisite registrations" do
            compliance_rows = csv.select do |row|
              row["charge_type"]&.start_with?("compliance") &&
                row["registration_no"]&.include?("/")
            end

            expect(compliance_rows).not_to be_empty
            compliance_rows.each do |row|
              expect(row["registration_no"]).to match(%r{/\d{5}$})
              expect(row["site"]).to match(/\d{5}/)
            end
          end

          it "only includes one summary row for a multisite registration" do
            summary_rows = csv.select do |row|
              row["charge_type"] == "summary" && row["registration_no"] == multisite_registration.reference
            end

            expect(summary_rows.count).to eq(1)
            expect(summary_rows.first["multisite"]).to eq("TRUE")
            expect(summary_rows.first["site"]).to be_nil
          end
        end

        context "when payments include back office comments" do
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          before do
            order
            registration
            account.payments.success.first.update!(comments: "Back office note")
          end

          it "shows payment comments in the comments column" do
            payment_row = csv.find { |row| row["payment_type"].present? }

            expect(payment_row["comments"]).to eq("Back office note")
          end
        end

        context "when a band has no compliance charge" do
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          before do
            order
            registration
            order.charge_detail.band_charge_details.each do |band_charge_detail|
              band_charge_detail.update!(band_id: order.exemptions.last.band_id)
            end

            order.charge_detail.band_charge_details.first.update!(
              initial_compliance_charge_amount: 0,
              additional_compliance_charge_amount: 0
            )
          end

          it "exports a compliance_no_charge row with zero amount" do
            no_charge_row = csv.find { |row| row["charge_type"] == "compliance_no_charge" }

            expect(no_charge_row).to be_present
            expect(no_charge_row["charge_amount"]).to eq("0")
          end
        end
      end
    end
  end
end
