# frozen_string_literal: true

require "rails_helper"
require "airbrake"

require "roles_and_permissions_loader"

RSpec.describe RolesAndPermissionsLoader do
  subject(:run_loader) { described_class.run }

  # Save these (loaded by the loader during Rails initialization) for restoration in the after block
  let!(:previous_roles_permissions) { Ability::ROLE_PERMISSIONS.dup }

  before do
    # The loader will have been run during Rails initialization; undo the loading before starting
    Ability::ROLE_PERMISSIONS.replace({})

    allow(Airbrake).to receive(:notify)
  end

  # Reload after expected failure specs to prevent errors in subsequent specs
  after { Ability::ROLE_PERMISSIONS = previous_roles_permissions }

  RSpec.shared_examples "handles errors" do
    it { expect { run_loader }.not_to raise_error }

    it "logs an error" do
      run_loader
      expect(Airbrake).to have_received(:notify)
    end
  end

  context "when the CSV file is missing" do
    before { allow(File).to receive(:read).and_raise(Errno::ENOENT) }

    it_behaves_like "handles errors"
  end

  context "when the CSV file content is invalid" do
    before { allow(File).to receive(:read).and_return("Foo") }

    it_behaves_like "handles errors"
  end

  context "when the CSV file content is valid" do
    it "does not log an error" do
      run_loader

      expect(Airbrake).not_to have_received(:notify)
    end

    it "populates the roles and permissions in the Ability class" do
      expect(Ability::ROLE_PERMISSIONS.keys.length).to be_zero
      expect { run_loader }.to change { Ability::ROLE_PERMISSIONS.keys.length }.from(0).to(4)
    end
  end
end
