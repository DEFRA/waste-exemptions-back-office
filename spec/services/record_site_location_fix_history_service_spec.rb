# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordSiteLocationFixHistoryService do
  subject(:run_service) { described_class.run(registration:) }

  let(:registration) { create(:registration, :with_active_exemptions) }
  let(:site_address) { registration.site_address }

  describe ".run", :versioning do
    before do
      registration.addresses.reload
      registration.reason_for_change = "Baseline site location"
      registration.paper_trail.save_with_version

      site_address.update!(grid_reference: "ST 58337 72855", area: "Wessex")
    end

    it "creates a registration version for the corrected site location" do
      expect { run_service }.to change { registration.reload.versions.count }.by(1)
    end

    it "records the system author and fix reason" do
      run_service

      change_history = RegistrationChangeHistoryService.run(registration)
      expect(change_history.last[:reason_for_change]).to eq(described_class::CHANGE_REASON)
      expect(change_history.last[:changed_by]).to eq(described_class::VERSION_AUTHOR)
    end
  end
end
