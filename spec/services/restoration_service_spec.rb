# frozen_string_literal: true

require "rails_helper"

RSpec.describe RestorationService do
  let(:admin_team_user) { build(:user, :admin_team_user) }
  let(:data_viewer_user) { build(:user, :data_viewer) }
  let(:restoration_message) { "This registration was deregistered in error." }
  let(:deregistration_message) { "This resource is no longer relevant." }
  let(:active_registration) do
    registration = create(:registration)
    registration.registration_exemptions.each do |re|
      re.state = "active"
      re.save!
    end
    registration
  end

  describe "#restore!" do
    context "when the resource is a revoked Registration" do
      subject(:restoration_service) { described_class.new(admin_team_user, registration) }

      let(:registration) do
        registration = active_registration
        registration.registration_exemptions.each do |re|
          re.revoke!
          re.deregistration_message = deregistration_message
          re.deregistered_by = admin_team_user.email
          re.save!
        end
        registration
      end

      it "changes the state of the registration" do
        expect { restoration_service.restore!(restoration_message) }
          .to change(registration, :state)
          .from("revoked")
          .to("active")
      end

      it "changes the state of all of the registration_exemptions" do
        restoration_service.restore!(restoration_message)

        registration.registration_exemptions.each do |re|
          expect(re.reload.state).to eq("active")
        end
      end

      it "clears the deregistration details of all of the registration_exemptions" do
        restoration_service.restore!(restoration_message)

        registration.registration_exemptions.each do |re|
          re.reload
          expect(re.deregistered_at).to be_nil
          expect(re.deregistration_message).to be_nil
          # deregistered_by falls back to the last version author, so read the column
          expect(re[:deregistered_by]).to be_nil
        end
      end

      it "records the restoration reason against all of the registration_exemptions" do
        restoration_service.restore!(restoration_message)

        registration.registration_exemptions.each do |re|
          expect(re.reload.reason_for_change).to eq(restoration_message)
        end
      end

      it "creates a version for all of the registration_exemptions", :versioning do
        restoration_service.restore!(restoration_message)

        registration.registration_exemptions.each do |re|
          expect(re.versions.last.whodunnit).to eq(admin_team_user.email)
        end
      end

      context "when the user has insufficient permissions" do
        subject(:restoration_service) { described_class.new(data_viewer_user, registration) }

        it "does not change the state of the registration" do
          expect { restoration_service.restore!(restoration_message) }
            .not_to change(registration, :state)
            .from("revoked")
        end
      end
    end

    context "when the resource is an active Registration" do
      subject(:restoration_service) { described_class.new(admin_team_user, active_registration) }

      it "does not change the state of the registration" do
        expect { restoration_service.restore!(restoration_message) }
          .not_to change(active_registration, :state)
          .from("active")
      end
    end

    context "when the resource is a ceased RegistrationExemption" do
      subject(:restoration_service) { described_class.new(admin_team_user, registration_exemption) }

      let(:registration_exemption) do
        re = active_registration.registration_exemptions.first
        re.cease!
        re.deregistration_message = deregistration_message
        re.deregistered_by = admin_team_user.email
        re.save!
        re
      end

      it "changes the registration_exemption state" do
        expect { restoration_service.restore!(restoration_message) }
          .to change(registration_exemption, :state)
          .from("ceased")
          .to("active")
      end

      it "clears the deregistration details" do
        restoration_service.restore!(restoration_message)
        registration_exemption.reload

        expect(registration_exemption.deregistered_at).to be_nil
        expect(registration_exemption.deregistration_message).to be_nil
      end

      it "does not change the other registration_exemptions" do
        restoration_service.restore!(restoration_message)

        active_registration.registration_exemptions.reject { |re| re.id == registration_exemption.id }.each do |re|
          expect(re.reload.state).to eq("active")
        end
      end

      context "when the user has insufficient permissions" do
        subject(:restoration_service) { described_class.new(data_viewer_user, registration_exemption) }

        it "does not change the registration_exemption state" do
          expect { restoration_service.restore!(restoration_message) }
            .not_to change(registration_exemption, :state)
            .from("ceased")
        end
      end
    end

    context "when the resource is an active RegistrationExemption" do
      subject(:restoration_service) { described_class.new(admin_team_user, registration_exemption) }

      let(:registration_exemption) { active_registration.registration_exemptions.first }

      it "does not change the registration_exemption state" do
        expect { restoration_service.restore!(restoration_message) }
          .not_to change(registration_exemption, :state)
          .from("active")
      end
    end
  end
end
