# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe ExemptionEprReportPresenter do
    let(:registration) { create(:registration) }
    let(:exemption) { create(:exemption) }
    let(:registration_exemption) do
      create(
        :registration_exemption,
        registration: registration,
        exemption: exemption
      )
    end

    subject(:presenter) { described_class.new(registration_exemption) }

    describe "#registration_number" do
      context "with a single-site registration" do
        let(:registration) { create(:registration) }

        it "returns the registration reference" do
          expect(presenter.registration_number).to eq(registration.reference)
        end
      end

      context "with a multi-site registration" do
        let(:multisite_registration) { create(:registration, :multisite_complete) }
        let(:site_address) { multisite_registration.site_addresses.last }
        let(:registration_exemption) { site_address.registration_exemptions.last }

        it "includes the site suffix with hyphen separator" do
          expect(presenter.registration_number).to eq("#{multisite_registration.reference}-#{site_address.site_suffix}")
        end

        context "when REPORT_SITE_SUFFIX_SEPARATOR is set" do
          before { allow(ENV).to receive(:fetch).with("REPORT_SITE_SUFFIX_SEPARATOR", "-").and_return("/") }

          it "uses the custom separator" do
            expect(presenter.registration_number).to eq("#{multisite_registration.reference}/#{site_address.site_suffix}")
          end
        end

        it "can access the registration for organisation data" do
          expect { presenter.organisation_name }.not_to raise_error
        end
      end
    end

    describe "#organisation_name" do
      let(:registration) { create(:registration, operator_name: "Awesome stuff") }

      it "rerturns the registration operator name" do
        expect(presenter.organisation_name).to eq("Awesome stuff")
      end
    end

    describe "#organisation_premises" do
      let(:operator_address) { create(:address, :operator_address, premises: "123 ABC") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator address premises" do
        expect(presenter.organisation_premises).to eq("123 ABC")
      end

      context "when the registration has no organisation address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.organisation_premises).to be_nil
        end
      end
    end

    describe "#organisation_street_address" do
      let(:operator_address) { create(:address, :operator_address, street_address: "32 Foo St") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator street address" do
        expect(presenter.organisation_street_address).to eq("32 Foo St")
      end

      context "when the registration has no organisation address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.organisation_street_address).to be_nil
        end
      end
    end

    describe "#organisation_locality" do
      let(:operator_address) { create(:address, :operator_address, locality: "Avon") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator address locality" do
        expect(presenter.organisation_locality).to eq("Avon")
      end

      context "when the registration has no organisation address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.organisation_street_address).to be_nil
        end
      end
    end

    describe "#organisation_city" do
      let(:operator_address) { create(:address, :operator_address, city: "Bristol") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator address city" do
        expect(presenter.organisation_city).to eq("Bristol")
      end

      context "when the registration has no organisation address" do
        let(:registration) { create(:registration, addresses: []) }

        it "returns nil" do
          expect(presenter.organisation_city).to be_nil
        end
      end
    end

    describe "#organisation_postcode" do
      let(:operator_address) { create(:address, :operator_address, postcode: "BS1 4RE") }
      let(:registration) { create(:registration, addresses: [operator_address]) }

      it "returns the operator address postcode" do
        expect(presenter.organisation_postcode).to eq("BS1 4RE")
      end
    end

    describe "#site_premises" do
      let(:site_address) { create(:address, :site_address, premises: "Bar 123") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the site address premises" do
        expect(presenter.site_premises).to eq("Bar 123")
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_premises).to be_nil
        end
      end
    end

    describe "#site_street_address" do
      let(:site_address) { create(:address, :site_address, street_address: "12 Baz road") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the site street address" do
        expect(presenter.site_street_address).to eq("12 Baz road")
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_street_address).to be_nil
        end
      end
    end

    describe "#site_locality" do
      let(:site_address) { create(:address, :site_address, locality: "Avon") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the site address locality" do
        expect(presenter.site_locality).to eq("Avon")
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_locality).to be_nil
        end
      end
    end

    describe "#site_city" do
      let(:site_address) { create(:address, :site_address, city: "Bristol") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the site address city" do
        expect(presenter.site_city).to eq("Bristol")
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_city).to be_nil
        end
      end
    end

    describe "#site_postcode" do
      let(:site_address) { create(:address, :site_address, postcode: "BS2 34G") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the site address postcode" do
        expect(presenter.site_postcode).to eq("BS2 34G")
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_postcode).to be_nil
        end
      end
    end

    describe "#site_country" do
      let(:site_address) { create(:address, :site_address, country_iso: "GB") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the site address country" do
        expect(presenter.site_country).to eq("GB")
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_country).to be_nil
        end
      end
    end

    describe "#site_ngr" do
      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_ngr).to be_nil
        end
      end

      context "when the site address has a postcode" do
        let(:site_address) { create(:address, :site_address, grid_reference: "SB1234", postcode: "AB12 3CD") }
        let(:registration_exemption) { create(:registration_exemption, address: site_address) }

        it "returns nil" do
          expect(presenter.site_ngr).to be_nil
        end
      end

      context "when the site address does not have a postcode" do
        let(:site_address) { create(:address, :site_address, grid_reference: "SB1234", postcode: nil) }
        let(:registration_exemption) { create(:registration_exemption, address: site_address) }

        it "returns the grid reference" do
          expect(presenter.site_ngr).to eq("SB1234")
        end
      end
    end

    describe "#site_easting" do
      let(:site_address) { create(:address, :site_address, x: "123.45") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the site address x coordinates" do
        expect(presenter.site_easting).to eq(123.45)
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_easting).to be_nil
        end
      end
    end

    describe "#site_northing" do
      let(:site_address) { create(:address, :site_address, y: "123.45") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the site address y coordinates" do
        expect(presenter.site_northing).to eq(123.45)
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.site_northing).to be_nil
        end
      end
    end

    describe "#ea_area_location" do
      let(:site_address) { create(:address, :site_address, area: "Foo") }
      let(:registration_exemption) { create(:registration_exemption, address: site_address) }

      it "returns the area name" do
        expect(presenter.ea_area_location).to eq("Foo")
      end

      context "when the exemption has no site address" do
        let(:registration_exemption) { create(:registration_exemption, address: nil) }

        it "returns nil" do
          expect(presenter.ea_area_location).to be_nil
        end
      end
    end

    describe "#exemption_code" do
      let(:exemption) { create(:exemption, code: "G12") }

      it "returns the exemption code" do
        expect(presenter.exemption_code).to eq("G12")
      end
    end

    describe "#exemption_registration_date" do
      let(:registration_exemption) { create(:registration_exemption, registered_on: Date.new(2019, 6, 1)) }

      it "returns the registered on date formatted" do
        expect(presenter.exemption_registration_date).to eq("2019-06-01")
      end
    end

    describe "#exemption_expiry_date" do
      let(:registration_exemption) { create(:registration_exemption, expires_on: Date.new(2019, 6, 1)) }

      it "returns the registered on date formatted" do
        expect(presenter.exemption_expiry_date).to eq("2019-06-01")
      end
    end

    describe "#site_is_on_a_farm" do
      context "when the site is on a farm" do
        let(:registration) { create(:registration, on_a_farm: true) }

        it { expect(presenter.site_is_on_a_farm).to eq "yes" }
      end

      context "when the site is not on a farm" do
        let(:registration) { create(:registration, on_a_farm: false) }

        it { expect(presenter.site_is_on_a_farm).to eq "no" }
      end
    end

    describe "#user_is_a_farmer" do
      context "when the user is a farmer" do
        let(:registration) { create(:registration, is_a_farmer: true) }

        it { expect(presenter.user_is_a_farmer).to eq "yes" }
      end

      context "when the user is not a farmer" do
        let(:registration) { create(:registration, is_a_farmer: false) }

        it { expect(presenter.user_is_a_farmer).to eq "no" }
      end
    end
  end
end
