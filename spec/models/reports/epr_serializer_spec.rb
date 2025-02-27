# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe EprSerializer do

    describe "#to_csv" do

      subject(:csv) { described_class.new.to_csv }

      let(:rows) { csv.split("\n") }
      let(:registrations_count) { rand(2..5) }
      let(:expected_columns) do
        %w[
          registration_number
          organisation_name
          organisation_premises
          organisation_street_address
          organisation_locality
          organisation_city
          organisation_postcode
          site_premises
          site_street_address
          site_locality
          site_city
          site_postcode
          site_country
          site_ngr
          site_easting
          site_northing
          ea_area_location
          site_is_on_a_farm
          user_is_a_farmer
          exemption_code
          exemption_registration_date
          exemption_expiry_date
        ]
      end

      before { create_list(:registration, registrations_count) }

      it "writes the column headers" do
        expect(rows.first).to eq(expected_columns.join(","))
      end

      it "writes a header row and a row for each registration exemption" do
        # The registration factory currently creates 3 registration_exemptions per registration
        expect(rows.length).to eq(1 + (registrations_count * 3))
      end

      it "writes exemption details as a string in CSV format" do
        expect(rows.last.split(",").length).to eq expected_columns.length
      end

      context "when the presenter encounters an error" do
        before do
          WasteExemptionsEngine::RegistrationExemption.first.update(registered_on: nil)
          allow(Rails.logger).to receive(:error)
          allow(Airbrake).to receive(:notify)
        end

        it "handles the error" do
          expect { csv }.not_to raise_error
        end

        it "logs the error in the Rails log" do
          csv

          expect(Rails.logger).to have_received(:error).at_least(:once)
        end

        it "notifies Airbrake of the error" do
          csv

          expect(Airbrake).to have_received(:notify).at_least(:once)
        end

        it "continues the export after the failed row" do
          expect(rows.length).to eq(registrations_count * 3)
        end
      end
    end
  end
end
