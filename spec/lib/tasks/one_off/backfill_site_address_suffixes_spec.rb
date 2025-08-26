# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:backfill_site_address_suffixes", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:backfill_site_address_suffixes"] }

  after { rake_task.reenable }

  let(:registration) { create(:registration) }
  let!(:site_address) { registration.site_address }

  context "when site addresses have no site_suffix" do
    before do
      site_address.update!(site_suffix: nil)

      allow(WasteExemptionsEngine::Address).to receive(:where)
        .with(address_type: "site", site_suffix: nil)
        .and_return([site_address])

      allow($stdout).to receive(:puts)
    end

    it "backfills site_suffix for site addresses with default value" do
      rake_task.invoke

      expect(site_address.reload.site_suffix).to eq("00001")
    end

    it "outputs progress information" do
      allow($stdout).to receive(:puts).with("Starting to backfill site_suffix on site addresses...")
      allow($stdout).to receive(:puts).with("Found 1 site addresses without site_suffix")
      allow($stdout).to receive(:puts).with("Completed backfilling site_suffix on site addresses.")
      allow($stdout).to receive(:puts).with("Total site addresses updated: 1")
      allow($stdout).to receive(:puts).with("Total errors: 0")

      rake_task.invoke

      expect($stdout).to have_received(:puts).with("Starting to backfill site_suffix on site addresses...")
      expect($stdout).to have_received(:puts).with("Found 1 site addresses without site_suffix")
      expect($stdout).to have_received(:puts).with("Completed backfilling site_suffix on site addresses.")
      expect($stdout).to have_received(:puts).with("Total site addresses updated: 1")
      expect($stdout).to have_received(:puts).with("Total errors: 0")
    end
  end

  context "when site addresses already have site_suffix" do
    before do
      site_address.update!(site_suffix: "00001")

      allow($stdout).to receive(:puts)
    end

    it "does not process site addresses that already have site_suffix" do
      allow(WasteExemptionsEngine::Address).to receive(:where)
        .with(address_type: "site", site_suffix: nil)
        .and_return([])

      rake_task.invoke

      expect(WasteExemptionsEngine::Address).to have_received(:where)
        .with(address_type: "site", site_suffix: nil)
    end

    it "outputs completion message with zero processed" do
      allow($stdout).to receive(:puts).with("Found 0 site addresses without site_suffix")

      rake_task.invoke

      expect($stdout).to have_received(:puts).with("Found 0 site addresses without site_suffix")
    end
  end

  context "when an error occurs during update" do
    before do
      site_address.update!(site_suffix: nil)

      allow(WasteExemptionsEngine::Address).to receive(:where)
        .with(address_type: "site", site_suffix: nil)
        .and_return([site_address])

      allow(site_address).to receive(:update!).and_raise(StandardError.new("Test error"))
      allow($stdout).to receive(:puts)
    end

    it "outputs error information" do
      allow($stdout).to receive(:puts).with("ERROR: Failed to update site address #{site_address.id}: Test error")

      rake_task.invoke

      expect($stdout).to have_received(:puts).with("ERROR: Failed to update site address #{site_address.id}: Test error")
    end

    it "continues processing and reports errors" do
      allow($stdout).to receive(:puts).with("Total errors: 1")
      allow($stdout).to receive(:puts).with(/Error details:.*#{site_address.id}.*Test error/)

      rake_task.invoke

      expect($stdout).to have_received(:puts).with("Total errors: 1")
      expect($stdout).to have_received(:puts).with(/Error details:.*#{site_address.id}.*Test error/)
    end
  end
end
