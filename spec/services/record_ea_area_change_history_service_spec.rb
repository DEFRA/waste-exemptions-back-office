# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordEaAreaChangeHistoryService do
  subject(:run_service) { described_class.run(registration:) }

  let(:registration) { create(:registration, :with_active_exemptions) }
  let(:site_address) { registration.site_address }

  describe ".run", :versioning do
    before do
      site_address.update!(area: "Thames")
      registration.addresses.reload
      registration.reason_for_change = "Baseline area"
      registration.paper_trail.save_with_version

      site_address.update!(area: "Wessex")
    end

    it "creates a registration version for changed EA areas" do
      expect { run_service }.to change { registration.reload.versions.count }.by(1)
    end

    it "records the EA area change in registration change history" do
      run_service

      change_history = RegistrationChangeHistoryService.run(registration)
      expect(change_history.last[:changed]).to include(["~", "addresses.site_area", "Thames", "Wessex"])
    end

    it "records the system author and reason for change" do
      run_service

      change_history = RegistrationChangeHistoryService.run(registration)
      expect(change_history.last[:reason_for_change]).to eq(described_class::CHANGE_REASON)
      expect(change_history.last[:changed_by]).to eq(described_class::VERSION_AUTHOR)
    end
  end
end
