# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:cleanup_duplicate_addresses", type: :rake do

  subject(:run_rake_task) { rake_task.invoke("live-run") }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:cleanup_duplicate_addresses"] }

  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  context "when running in dry run mode (default)" do
    let(:registration) { create(:registration) }

    before do
      create(:address, :site_address, registration: registration)
    end

    it "does not delete any addresses" do
      expect do
        rake_task.invoke
      end.not_to change(WasteExemptionsEngine::Address, :count)
    end
  end

  context "when a registration has duplicate site addresses" do
    let(:registration) { create(:registration) }
    let(:kept_address) { registration.addresses.find_by(address_type: "site") }

    before do
      # Create a duplicate site address with no exemptions
      create(:address, :site_address, registration: registration)
    end

    it "removes the duplicate" do
      expect { run_rake_task }.to change {
        registration.addresses.where(address_type: "site").count
      }.from(2).to(1)
    end

    it "keeps the address that has registration_exemptions" do
      run_rake_task

      expect(registration.addresses.where(address_type: "site").pluck(:id)).to eq([kept_address.id])
    end
  end

  context "when a registration has duplicate operator addresses" do
    let(:registration) { create(:registration) }

    before do
      create(:address, :operator_address, registration: registration)
    end

    it "removes the duplicate" do
      expect { run_rake_task }.to change {
        registration.addresses.where(address_type: "operator").count
      }.from(2).to(1)
    end

    it "keeps the first address (lowest id)" do
      first_id = registration.addresses.where(address_type: "operator").order(:id).first.id

      run_rake_task

      expect(registration.addresses.where(address_type: "operator").pluck(:id)).to eq([first_id])
    end
  end

  context "when a registration has duplicate contact addresses" do
    let(:registration) { create(:registration) }

    before do
      create(:address, :contact_address, registration: registration)
    end

    it "removes the duplicate" do
      expect { run_rake_task }.to change {
        registration.addresses.where(address_type: "contact").count
      }.from(2).to(1)
    end
  end

  context "when the duplicate address has exemptions and the other does not" do
    let(:registration) { create(:registration) }
    let!(:address_with_exemptions) { registration.addresses.find_by(address_type: "site") }

    before do
      create(:address, :site_address, registration: registration)
    end

    it "keeps the address with exemptions" do
      run_rake_task

      remaining = registration.addresses.where(address_type: "site")
      expect(remaining.count).to eq(1)
      expect(remaining.first.id).to eq(address_with_exemptions.id)
    end

    it "does not delete any registration_exemptions" do
      expect { run_rake_task }.not_to change {
        registration.registration_exemptions.count
      }
    end
  end

  context "when neither duplicate has exemptions" do
    let(:registration) { create(:registration) }

    before do
      # Remove exemptions from the site address
      registration.registration_exemptions.update_all(address_id: nil) # rubocop:disable Rails/SkipsModelValidations
      create(:address, :site_address, registration: registration)
    end

    it "keeps the first address (lowest id)" do
      first_id = registration.addresses.where(address_type: "site").order(:id).first.id

      run_rake_task

      remaining = registration.addresses.where(address_type: "site")
      expect(remaining.count).to eq(1)
      expect(remaining.first.id).to eq(first_id)
    end
  end

  context "when a legitimate multisite registration has multiple site addresses" do
    before { create(:registration, :multisite_complete) }

    it "does not remove any site addresses" do
      expect { run_rake_task }.not_to change(WasteExemptionsEngine::Address.where(address_type: "site"), :count)
    end
  end

  context "when a registration has no duplicate addresses" do
    before { create(:registration) }

    it "does not modify any addresses" do
      expect { run_rake_task }.not_to change(WasteExemptionsEngine::Address, :count)
    end
  end
end
