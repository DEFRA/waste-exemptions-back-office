# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteGridReferenceForm, type: :model do
    let(:source_registration) { create(:registration) }
    let(:transient_registration) { WasteExemptionsEngine::BackOfficeEditRegistration.new(reference: source_registration.reference) }
    let(:existing_site) { transient_registration.site_addresses.first }
    let(:form) { described_class.new(transient_registration) }

    shared_examples "updates existing site address without creating duplicates" do
      let(:params) { { grid_reference: "ST 12345 67890", description: "Updated site description" } }

      it "updates the existing site record" do
        expect do
          form.submit(params)
          existing_site.reload
        end.to change(existing_site, :grid_reference).to("ST 12345 67890")
                                                     .and change(existing_site, :description).to("Updated site description")
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

      context "when editing multisite registration address" do
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
