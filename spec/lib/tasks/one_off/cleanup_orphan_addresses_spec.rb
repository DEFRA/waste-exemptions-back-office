# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:cleanup_orphan_addresses", type: :rake do

  subject(:run_rake_task) { rake_task.invoke("live-run") }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:cleanup_orphan_addresses"] }

  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  context "when running in dry run mode (default)" do
    before do
      create(:address, address_type: 1, mode: 1, registration_id: nil)
    end

    it "does not delete any addresses" do
      expect do
        rake_task.invoke
      end.not_to change { WasteExemptionsEngine::Address.where(registration_id: nil).count }
    end
  end

  context "when there are orphan addresses with no registration" do
    before do
      create(:address, address_type: 1, mode: 1, registration_id: nil)
      create(:address, address_type: 3, mode: 1, registration_id: nil)
    end

    it "deletes the orphan addresses" do
      expect { run_rake_task }.to change {
        WasteExemptionsEngine::Address.where(registration_id: nil).count
      }.by(-2)
    end
  end

  context "when there are orphan transient_addresses" do
    before do
      create(:transient_address, address_type: 3, mode: 1, transient_registration_id: nil)
      create(:transient_address, address_type: 3, mode: 1, transient_registration_id: nil)
    end

    it "deletes the orphan transient_addresses" do
      expect { run_rake_task }.to change {
        WasteExemptionsEngine::TransientAddress.where(transient_registration_id: nil).count
      }.by(-2)
    end
  end
end
