# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Address do
  let(:matching_address_site) { create(:address, :site_address) }
  let(:matching_address_contact) { create(:address, :contact_address) }
  let(:matching_address_operator) { create(:address, :operator_address) }
  let(:non_matching_address) { create(:address) }
  let(:nccc_address) { create(:address, :contact_address, postcode: "S9 4WF") }
  let(:non_nccc_address) { create(:address, :contact_address, postcode: "AA1 1AA") }

  describe "#search_for_postcode" do
    let(:term) { nil }
    let(:scope) { described_class.search_for_postcode(term) }

    context "when the search term is a postcode" do
      let(:term) { matching_address_operator.postcode }

      it "returns addresses with a matching postcode" do
        expect(scope).to include(matching_address_operator)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_address)
      end
    end
  end

  describe "#site" do
    let(:scope) { described_class.site }

    it "returns site addresses" do
      expect(scope).to include(matching_address_site)
    end

    it "does not return others" do
      expect(scope).not_to include(non_matching_address)
    end
  end

  describe "#contact" do
    let(:scope) { described_class.contact }

    it "returns contact addresses" do
      expect(scope).to include(matching_address_contact)
    end

    it "does not return others" do
      expect(scope).not_to include(non_matching_address)
    end
  end

  describe "#operator" do
    let(:scope) { described_class.operator }

    it "returns operator addresses" do
      expect(scope).to include(matching_address_operator)
    end

    it "does not return others" do
      expect(scope).not_to include(non_matching_address)
    end
  end

  describe "#nccc" do
    let(:scope) { described_class.nccc }

    it "returns NCCC addresses" do
      expect(scope).to include(nccc_address)
    end

    it "does not return non-NCCC addresses" do
      expect(scope).not_to include(non_nccc_address)
    end
  end

  describe "#not_nccc" do
    let(:scope) { described_class.not_nccc }

    it "returns non-NCCC addresses" do
      expect(scope).to include(non_nccc_address)
    end

    it "does not return NCCC addresses" do
      expect(scope).not_to include(nccc_address)
    end
  end

  describe "#reference" do
    let(:address) { build(:address, :site_address, registration:) }

    shared_examples "returns the registration reference" do
      before { address.update(site_suffix: nil) }

      it { expect(address.reference).to eq(registration.reference) }
    end

    shared_examples "returns the registration reference and site suffix" do
      before { address.update(site_suffix: "ABC") }

      it { expect(address.reference).to eq("#{registration.reference}/ABC") }
    end

    context "when registration is single-site" do
      let(:registration) { build(:registration) }

      context "when site_suffix is nil or empty" do
        it_behaves_like "returns the registration reference"
      end

      context "when site_suffix is set" do
        it_behaves_like "returns the registration reference and site suffix"
      end
    end

    context "when registration is multi-site" do
      let(:registration) { build(:registration, :multisite) }

      context "when site_suffix is nil or empty" do
        it_behaves_like "returns the registration reference"
      end

      context "when site_suffix is set" do
        it_behaves_like "returns the registration reference and site suffix"
      end
    end
  end

  describe "#site_status" do

    context "when registration is single-site" do
      let(:site_address) { create(:address, :site_address) }
      let(:registration_exemption_active) { create(:registration_exemption, :active) }
      let(:registration_exemption_ceased) { create(:registration_exemption, :ceased) }
      let(:registration_exemption_revoked) { create(:registration_exemption, :revoked) }
      let(:registration_exemption_expired) { create(:registration_exemption, :expired) }
      let(:registration) { create(:registration, site_addresses: [site_address], registration_exemptions: registration_exemptions) }

      shared_examples "returns site status" do |expected_status|
        it { expect(site_address.site_status).to eq(expected_status) }
      end

      before { registration }

      context "when registration has any active exemptions" do
        let(:registration_exemptions) do
          [
            registration_exemption_active,
            registration_exemption_ceased,
            registration_exemption_revoked
          ]
        end

        it_behaves_like "returns site status", "active"
      end

      context "when registration has any expired exemptions" do
        let(:registration_exemptions) do
          [
            registration_exemption_expired,
            registration_exemption_ceased,
            registration_exemption_revoked
          ]
        end

        it_behaves_like "returns site status", "expired"
      end

      context "when registration does not have active or expired exemptions" do
        let(:registration_exemptions) do
          [
            registration_exemption_ceased,
            registration_exemption_revoked
          ]
        end

        it_behaves_like "returns site status", "deregistered"
      end
    end

    context "when registration is multi-site" do
      let(:registration) { create(:registration, :multisite_complete) }
      let(:site_address) { registration.site_addresses.sample }
      let(:registration_exemptions) { site_address.registration_exemptions }
      let(:registration_exemption) { registration_exemptions.sample }

      shared_examples "returns site status" do |expected_status|
        it { expect(site_address.site_status).to eq(expected_status) }
      end

      before do
        registration
        registration_exemption
      end

      context "when address has any active registration_exemptions" do
        before { registration_exemption.update(state: "active") }

        it_behaves_like "returns site status", "active"
      end

      context "when registration has all expired exemptions" do
        before { registration_exemptions.map { |re| re.update(state: "expired") } }

        it_behaves_like "returns site status", "expired"
      end

      context "when registration does not have active or expired exemptions" do
        before { registration_exemptions.map { |re| re.update(state: %w[ceased revoked].sample) } }

        it_behaves_like "returns site status", "deregistered"
      end
    end
  end

  describe "#ceased_or_revoked_exemptions" do

    shared_examples "returns an empty string" do
      it { expect(address.ceased_or_revoked_exemptions).to be_blank }
    end

    context "when registration is single-site" do
      let(:address) { create(:address, :site_address) }

      context "when registration has ceased exemptions" do
        let(:registration) { create(:registration, :with_ceased_exemptions, site_addresses: [address]) }

        it "returns a comma-separated list of ceased or revoked exemption codes" do
          expected_codes = registration.registration_exemptions.map(&:exemption).map(&:code).join(", ")

          expect(address.ceased_or_revoked_exemptions).to eq(expected_codes)
        end
      end

      context "when registration has no ceased exemptions" do
        let(:registration) { create(:registration) }

        it_behaves_like "returns an empty string"
      end
    end

    context "when registration is multi-site" do
      let(:registration) { create(:registration, :multisite, registration_exemptions: []) }

      context "when registration has ceased exemptions" do
        let(:registration_exemption) { create(:registration_exemption, :ceased) }
        let(:address) { create(:address, :site_address, registration:, registration_exemptions: [registration_exemption]) }

        it "returns a comma-separated list of ceased or revoked exemption codes" do
          expect(address.ceased_or_revoked_exemptions).to eq(registration_exemption.exemption.code)
        end
      end

      context "when registration has no ceased exemptions" do
        let(:registration_exemption) { create(:registration_exemption, :active) }
        let(:address) { create(:address, :site_address, registration:, registration_exemptions: [registration_exemption]) }

        it_behaves_like "returns an empty string"
      end
    end
  end
end
