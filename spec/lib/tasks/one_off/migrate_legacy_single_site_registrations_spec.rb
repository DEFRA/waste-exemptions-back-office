# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:migrate_legacy_single_site_registrations", type: :rake do

  subject(:run_rake_task) { rake_task.invoke }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:migrate_legacy_single_site_registrations"] }

  before { WasteExemptionsEngine::Address.destroy_all }

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  context "when the registration is true multisite" do
    before { create(:registration, :multisite_complete) }

    it "does not modify the registration" do
      expect { run_rake_task }.not_to change(WasteExemptionsEngine::Registration, :last)
    end
  end

  context "when the registration is a single-site registration using the multisite data model" do
    before do
      reg = create(:registration)
      reg.site_address.update(registration_exemptions: reg.registration_exemptions)
    end

    it "does not modify the registration" do
      expect { run_rake_task }.not_to change(WasteExemptionsEngine::Registration, :last)
    end
  end

  context "when the registration is legacy single-site" do
    let(:registration) { WasteExemptionsEngine::Registration.last }
    let(:site_address) { registration.site_address }

    before { create(:registration) }

    it "adds registration_exemptions on the site_address" do
      expect { run_rake_task }.to change { site_address.reload.registration_exemptions.count }.from(0)
    end

    it "creates a site_address association with each registration_exemption" do
      run_rake_task

      expect(site_address.registration_exemptions).to match_array(registration.registration_exemptions)
    end

    it "removes the association from the registration to the site_address" do
      run_rake_task

      expect(registration.registration_exemptions.where(address: nil)).to be_empty
      expect(registration.site_address.registration_exemptions).to match_array(registration.registration_exemptions)
    end
  end
end
