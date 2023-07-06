# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:delete_all_exemptions_of_a_given_type", type: :rake do

  subject(:run_rake_task) { rake_task.invoke(exemption_code) }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:delete_all_exemptions_of_a_given_type"] }
  let(:exemption_code) { "XYZ" }
  let(:xyz_exemption) { create(:exemption, code: exemption_code) }
  let(:cease_message) { "Ceased due to #{exemption_code} bulk removal, removal of #{exemption_code} exemption" }

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  context "when processing registration_exemptions" do
    let(:non_xyz_registration_exemption) { create(:registration_exemption, state: "active") }
    let(:active_xyz_registration_exemption) { create(:registration_exemption, exemption: xyz_exemption, state: "active") }
    let(:inactive_xyz_registration_exemption) { create(:registration_exemption, exemption: xyz_exemption, state: "revoked") }
    let(:registration) { create(:registration) }

    # The registration_exemptions don't really need to belong to a registration; this is just for completeness.
    before do
      registration.registration_exemptions << non_xyz_registration_exemption
      registration.registration_exemptions << active_xyz_registration_exemption
      registration.registration_exemptions << inactive_xyz_registration_exemption
    end

    it "ceases the active XYZ exemption" do
      run_rake_task

      expect(active_xyz_registration_exemption.reload.state).to eq "ceased"
    end

    it "sets the correct deregistration message" do
      run_rake_task

      expect(active_xyz_registration_exemption.reload.deregistration_message).to eq cease_message
    end

    it "sets the correct deregistration time" do
      run_rake_task

      expect(active_xyz_registration_exemption.reload.deregistered_at).to eq Time.zone.today
    end

    it "does not cease other registration_exemptions" do
      expect { run_rake_task }.not_to change { non_xyz_registration_exemption.reload.state }
    end

    it "does not cease an inactive xyz registration exemption" do
      expect { run_rake_task }.not_to change { inactive_xyz_registration_exemption.reload.state }
    end
  end

  context "when processing transient_registrations" do
    let(:xyz_transient_registration) { create(:renewing_registration) }
    let(:other_registration) { create(:renewing_registration) }
    let(:active_xyz_registration_exemption) { create(:transient_registration_exemption, exemption: xyz_exemption, state: "active") }

    before { xyz_transient_registration.registration_exemptions << active_xyz_registration_exemption }

    it "deletes the transient_registration with the XYZ exemption" do
      expect { run_rake_task }
        .to change { WasteExemptionsEngine::TransientRegistration.find_by(reference: xyz_transient_registration.reference) }.to(nil)
    end

    it "does not delete the non-XYZ transient_registration" do
      expect { run_rake_task }
        .not_to change { WasteExemptionsEngine::TransientRegistration.find_by(reference: other_registration.reference) }
    end
  end
end
