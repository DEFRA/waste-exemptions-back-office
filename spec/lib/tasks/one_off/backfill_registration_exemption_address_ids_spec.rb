# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:backfill_registration_exemption_address_ids", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:backfill_registration_exemption_address_ids"] }

  let(:registration) { create(:registration, registration_exemptions: []) }
  let(:site_address) { registration.site_address }
  let!(:registration_exemption) { create(:registration_exemption, registration: registration) }

  before do
    WasteExemptionsEngine::RegistrationExemption.where.not(id: registration_exemption.id).destroy_all
  end

  after do
    rake_task.reenable
  end

  context "when registration_exemptions have no address_id" do
    before do
      registration_exemption.update!(address_id: nil)

      allow($stdout).to receive(:puts)
    end

    it "backfills address_id for registration_exemptions" do
      rake_task.invoke

      expect(registration_exemption.reload.address_id).to eq(site_address.id)
    end

    it "outputs progress information" do
      allow($stdout).to receive(:puts).with("Starting to backfill address_id on registration_exemptions...")
      allow($stdout).to receive(:puts).with("Found 1 registration_exemptions without address_id")
      allow($stdout).to receive(:puts).with("Completed backfilling address_id on registration_exemptions.")
      allow($stdout).to receive(:puts).with("Total registration_exemptions updated: 1")
      allow($stdout).to receive(:puts).with("Total errors: 0")

      rake_task.invoke

      expect($stdout).to have_received(:puts).with("Starting to backfill address_id on registration_exemptions...")
      expect($stdout).to have_received(:puts).with("Found 1 registration_exemptions without address_id")
      expect($stdout).to have_received(:puts).with("Completed backfilling address_id on registration_exemptions.")
      expect($stdout).to have_received(:puts).with("Total registration_exemptions updated: 1")
      expect($stdout).to have_received(:puts).with("Total errors: 0")
    end
  end

  context "when registration has no site_address" do
    let(:registration_without_site) { create(:registration, addresses: []) }
    let!(:registration_exemption_without_site) { create(:registration_exemption, registration: registration_without_site) }

    before do
      registration_exemption_without_site.update!(address_id: nil)

      allow($stdout).to receive(:puts)
    end

    it "outputs warning for registration without site_address" do
      allow($stdout).to receive(:puts).with(/WARNING: Registration #{registration_without_site.id} has no site_address/)

      rake_task.invoke

      expect($stdout).to have_received(:puts).with(/WARNING: Registration #{registration_without_site.id} has no site_address/).once
    end

    it "does not update the registration_exemption" do
      rake_task.invoke

      expect(registration_exemption_without_site.reload.address_id).to be_nil
    end
  end

  context "when registration_exemptions already have address_id" do
    before do
      registration_exemption.update!(address_id: site_address.id)

      allow($stdout).to receive(:puts)
    end

    it "does not process registration_exemptions that already have address_id" do
      rake_task.invoke

      expect(registration_exemption.reload.address_id).to eq(site_address.id)
    end

    it "outputs completion message with zero processed" do
      allow($stdout).to receive(:puts).with("Found 0 registration_exemptions without address_id")

      rake_task.invoke

      expect($stdout).to have_received(:puts).with("Found 0 registration_exemptions without address_id")
    end
  end

  context "when an error occurs during update" do
    before do
      registration_exemption.update!(address_id: nil)
      allow(registration_exemption).to receive(:update!).and_raise(StandardError.new("Test error"))
      relation = instance_double(ActiveRecord::Relation)
      enumerator = instance_double(Enumerator)
      allow(enumerator).to receive(:with_index).and_yield(registration_exemption, 0)
      allow(relation).to receive_messages(find_each: enumerator, count: 1)
      allow(WasteExemptionsEngine::RegistrationExemption).to receive(:where).and_return(relation)
      allow($stdout).to receive(:puts)
    end

    it "outputs error information" do
      allow($stdout).to receive(:puts).with("ERROR: Failed to update registration_exemption #{registration_exemption.id}: Test error")

      rake_task.invoke

      expect($stdout).to have_received(:puts).with("ERROR: Failed to update registration_exemption #{registration_exemption.id}: Test error")
    end

    it "continues processing and reports errors" do
      allow($stdout).to receive(:puts).with("Total errors: 1")
      allow($stdout).to receive(:puts).with(/Error details:.*#{registration_exemption.id}.*Test error/)

      rake_task.invoke

      expect($stdout).to have_received(:puts).with("Total errors: 1")
      expect($stdout).to have_received(:puts).with(/Error details:.*#{registration_exemption.id}.*Test error/)
    end
  end
end
