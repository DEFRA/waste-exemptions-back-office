# frozen_string_literal: true

require "rails_helper"

RSpec.describe CheckEaAreaService do
  subject(:run_service) { described_class.run(batch_size: batch_size, logger: logger) }

  let(:batch_size) { 2 }
  let(:logger) { instance_spy(Logger) }

  before do
    allow(WasteExemptionsEngine::DetermineAreaService).to receive(:run).and_return("Wessex")
    allow(Airbrake).to receive(:notify)
  end

  describe ".run" do
    context "with an active single-site registration" do
      let(:registration) { create(:registration, :with_active_exemptions) }
      let(:site_address) { registration.site_address }

      before do
        site_address.update!(area: nil, x: 358_130.1, y: 172_687.87)
      end

      it "updates a missing EA area" do
        expect { run_service }.to change { site_address.reload.area }.from(nil).to("Wessex")
      end

      it "logs changed EA areas with registration and site information" do
        run_service

        expect(logger).to have_received(:info).with(
          a_string_including(
            "EA area updated",
            "registration_reference=#{registration.reference.inspect}",
            "site_address_id=#{site_address.id}",
            "previous_area=nil",
            'new_area="Wessex"'
          )
        )
      end

      it "returns a processing summary" do
        expect(run_service).to include(
          registrations_checked: 1,
          sites_checked: 1,
          sites_updated: 1,
          site_errors: 0
        )
      end

      context "when the site already has a different EA area" do
        before { site_address.update!(area: "Thames") }

        it "updates the EA area" do
          expect { run_service }.to change { site_address.reload.area }.from("Thames").to("Wessex")
        end
      end

      context "when the site already has the correct EA area" do
        before { site_address.update!(area: "Wessex") }

        it "does not update the site" do
          expect { run_service }.not_to change { site_address.reload.updated_at }
        end
      end
    end

    context "with inactive registrations and sites" do
      let(:active_registration) { create(:registration, :with_active_exemptions) }
      let(:expired_registration) do
        create(:registration, registration_exemptions: [build(:registration_exemption, :expired)])
      end

      let(:multisite_registration) do
        create(
          :registration,
          :multisite,
          registration_exemptions: [],
          addresses: [
            build(:address, :operator_address),
            build(:address, :contact_address)
          ]
        )
      end
      let(:active_multisite_site) do
        create(:address, :site_address, registration: multisite_registration, site_suffix: "00001", area: "Old area")
      end
      let(:inactive_multisite_site) do
        create(:address, :site_address, registration: multisite_registration, site_suffix: "00002", area: "Old area")
      end

      before do
        active_registration.site_address.update!(area: "Old area")
        expired_registration.site_address.update!(area: "Old area")

        create(
          :registration_exemption,
          :active,
          registration: multisite_registration,
          address: active_multisite_site
        )
        create(
          :registration_exemption,
          :ceased,
          registration: multisite_registration,
          address: inactive_multisite_site
        )
      end

      it "checks active registrations and active multisite sites only" do
        run_service

        expect(active_registration.site_address.reload.area).to eq("Wessex")
        expect(expired_registration.site_address.reload.area).to eq("Old area")
        expect(active_multisite_site.reload.area).to eq("Wessex")
        expect(inactive_multisite_site.reload.area).to eq("Old area")
      end
    end

    context "when an EA area lookup errors" do
      let(:registration) { create(:registration, :with_active_exemptions) }
      let(:site_address) { registration.site_address }

      before do
        site_address.update!(area: nil)
        allow(WasteExemptionsEngine::DetermineAreaService).to receive(:run).and_raise(StandardError, "lookup failed")
      end

      it "logs the error and continues" do
        expect { run_service }.not_to raise_error

        expect(logger).to have_received(:error).with(
          a_string_including(
            "EA area check error",
            "registration_reference=#{registration.reference.inspect}",
            "site_address_id=#{site_address.id}",
            "error_class=StandardError",
            'error_message="lookup failed"'
          )
        )
      end

      it "notifies Airbrake" do
        run_service

        expect(Airbrake).to have_received(:notify).with(
          an_instance_of(StandardError),
          hash_including(
            registration_id: registration.id,
            registration_reference: registration.reference,
            site_address_id: site_address.id
          )
        )
      end
    end

    context "when an EA area lookup returns no area" do
      let(:registration) { create(:registration, :with_active_exemptions) }
      let(:site_address) { registration.site_address }

      before do
        site_address.update!(area: nil)
        allow(WasteExemptionsEngine::DetermineAreaService).to receive(:run).and_return(nil)
      end

      it "logs the site for investigation" do
        expect(run_service).to include(site_errors: 1)

        expect(logger).to have_received(:error).with(
          a_string_including(
            "EA area check error",
            "error_class=CheckEaAreaService::EaAreaLookupError",
            'error_message="EA area lookup returned no area"'
          )
        )
      end
    end
  end

  describe "change history", :versioning do
    let(:registration) { create(:registration, :with_active_exemptions) }
    let(:site_address) { registration.site_address }

    before do
      site_address.update!(area: "Thames")
      registration.addresses.reload
      registration.reason_for_change = "Baseline area"
      registration.paper_trail.save_with_version
    end

    it "creates a registration version for changed EA areas" do
      expect { run_service }.to change { registration.reload.versions.count }.by(1)

      change_history = RegistrationChangeHistoryService.run(registration)
      expect(change_history.last[:changed]).to include(["~", "addresses.site_area", "Thames", "Wessex"])
      expect(change_history.last[:reason_for_change]).to eq(described_class::CHANGE_REASON)
      expect(change_history.last[:changed_by]).to eq(described_class::VERSION_AUTHOR)
    end
  end
end
