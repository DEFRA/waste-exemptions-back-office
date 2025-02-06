# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe DataSerializer do
      let(:account) { create(:account) }
      let(:order) { create(:order, :with_charge_detail, order_owner: account) }
      let(:charge_adjustment) { create(:charge_adjustment, account: account) }
      let(:registration) { create(:registration, account: account) }

      let(:serializer) { described_class.new }

      shared_examples "a valid registration charge row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_number"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to eq("registration")
          expect(csv[row_number]["charge_amount"]).to be_present
          expect(csv[row_number]["charge_band"]).to be_nil
        end
      end

      shared_examples "a valid initial compliance charge row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_number"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to eq("compliance_initial")
          expect(csv[row_number]["charge_amount"]).to be_present
          expect(csv[row_number]["charge_band"]).to be_present
        end
      end

      shared_examples "a valid additional compliance charge row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_number"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to eq("compliance_additional")
          expect(csv[row_number]["charge_amount"]).to be_present
          expect(csv[row_number]["charge_band"]).to be_present
        end
      end

      shared_examples "a valid charge adjustment row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_number"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to eq("charge_adjust")
          expect(csv[row_number]["charge_amount"]).to be_present
          expect(csv[row_number]["charge_band"]).to be_nil
        end
      end

      shared_examples "a valid registration empty row" do |row_number|
        it "generates correct row" do
          expect(csv[row_number]["registration_number"]).to eq(registration.reference)
          expect(csv[row_number]["date"]).to eq(Time.zone.now.strftime("%d/%m/%Y"))
          expect(csv[row_number]["charge_type"]).to be_nil
          expect(csv[row_number]["charge_amount"]).to be_nil
          expect(csv[row_number]["charge_band"]).to be_nil
        end
      end

      describe "#to_csv" do
        before do
          order
          charge_adjustment
          registration
        end

        context "when CSV output is generated" do
          let(:csv) { CSV.parse(serializer.to_csv, headers: true) }

          it "generates correct header" do
            expect(csv.headers).to eq(%w[registration_number date charge_type charge_amount charge_band])
          end

          it_behaves_like "a valid registration charge row", 0

          it_behaves_like "a valid initial compliance charge row", 1
          it_behaves_like "a valid additional compliance charge row", 2

          it_behaves_like "a valid initial compliance charge row", 3
          it_behaves_like "a valid additional compliance charge row", 4

          it_behaves_like "a valid initial compliance charge row", 5
          it_behaves_like "a valid additional compliance charge row", 6

          it_behaves_like "a valid charge adjustment row", 7
          it_behaves_like "a valid registration empty row", 8
        end
      end
    end
  end
end
