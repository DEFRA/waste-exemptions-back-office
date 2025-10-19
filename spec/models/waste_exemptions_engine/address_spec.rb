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
    let(:address) { build(:address, :site_address, registration:) }

    shared_examples "returns deregistered" do
      it { expect(address.site_status).to eq("deregistered") }
    end

    shared_examples "returns active" do
      it { expect(address.site_status).to eq("active") }
    end

    context "when registration is single-site" do
      let(:registration_exemption) { build(:registration_exemption, :active) }
      let(:registration) { build(:registration, registration_exemptions: [registration_exemption]) }

      context "when registration has active exemptions" do
        it_behaves_like "returns active"
      end

      context "when registration does not have active exemptions" do
        before { registration_exemption.update(state: "ceased") }

        it_behaves_like "returns deregistered"
      end
    end

    context "when registration is multi-site" do
      let(:registration) { build(:registration, :multisite, registration_exemptions: []) }
      let(:registration_exemption) { build(:registration_exemption, :active) }

      before do
        address.registration_exemptions << registration_exemption
      end

      context "when site has active registration exemptions" do
        it_behaves_like "returns active"
      end

      context "when site does not have active registration exemptions" do
        before { registration_exemption.update(state: "ceased") }

        it_behaves_like "returns deregistered"
      end
    end
  end

  describe "#ceased_or_revoked_exemptions" do

    shared_examples "returns an empty sring" do
      it { expect(address.ceased_or_revoked_exemptions).to be_blank }
    end

    context "when registration is single-site" do
      let(:address) { create(:address, :site_address, registration:) }

      context "when registration has ceased exemptions" do
        let(:registration) { create(:registration, :with_ceased_exemptions) }

        it "returns a comma-separated list of ceased or revoked exemption codes" do
          expected_codes = registration.registration_exemptions.map(&:exemption).map(&:code).join(", ")
          expect(address.ceased_or_revoked_exemptions).to eq(expected_codes)
        end
      end

      context "when registration has no ceased exemptions" do
        let(:registration) { create(:registration) }

        it_behaves_like "returns an empty sring"
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

        it_behaves_like "returns an empty sring"
      end
    end
  end
end
