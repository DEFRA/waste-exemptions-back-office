# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteAddressLookupForm, type: :model do
    let(:source_registration) { create(:registration) }
    let(:transient_registration) { WasteExemptionsEngine::BackOfficeEditRegistration.new(reference: source_registration.reference) }
    let(:existing_site) { transient_registration.site_addresses.last }
    let(:form) { described_class.new(transient_registration) }
    let(:address_data) do
      {
        "uprn" => 340_116,
        "premises" => "Horizon House",
        "street_address" => "Deanery Road",
        "city" => "Bristol",
        "postcode" => "BS1 5AH",
        "x" => "358205.03",
        "y" => "172708.07",
        "country_iso" => "E"
      }
    end
    let(:address_lookup_response) { instance_double(DefraRuby::Address::Response, results: [address_data]) }

    before do
      allow(AddressLookupService).to receive(:run).with("BS1 5AH").and_return(address_lookup_response)
      transient_registration.update!(temp_site_postcode: "BS1 5AH")
    end

    shared_examples "updates existing site address without creating duplicates" do
      let(:params) { { site_address: { uprn: "340116" } } }

      it "updates the existing site record" do
        expect do
          form.submit(params)
          existing_site.reload
        end.to change(existing_site, :uprn).to("340116")
      end

      it "doesn't create a duplicate" do
        expect do
          form.submit(params)
        end.not_to change(transient_registration.transient_addresses, :count)
      end
    end

    context "when editing registration in the back office" do
      before do
        transient_registration.update!(temp_site_id: existing_site.id)
      end

      context "when editing an existing multisite address in back office" do
        let(:source_registration) { create(:registration, :multisite_complete) }

        it_behaves_like "updates existing site address without creating duplicates"
      end

      context "when editing single-site registration address with no foreign-keys to registration_exemptions" do
        before do
          transient_registration.transient_registration_exemptions.each do |exemption|
            exemption.update!(transient_address_id: nil)
          end
        end

        it_behaves_like "updates existing site address without creating duplicates"
      end

      context "when editing single-site registration address with foreign-keys to registration_exemptions" do
        before do
          transient_registration.transient_registration_exemptions.each do |exemption|
            exemption.update!(transient_address_id: existing_site.id)
          end
        end

        it_behaves_like "updates existing site address without creating duplicates"
      end
    end
  end
end
