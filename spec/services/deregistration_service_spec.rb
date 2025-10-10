# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeregistrationService do
  let(:admin_team_user) { build(:user, :admin_team_user) }
  let(:data_viewer_user) { build(:user, :data_viewer) }
  let(:deregistration_message) { "This resource is no longer relevant." }

  describe "#deregister!" do
    context "when the resource is a Registration" do
      context "when the registration is active" do
        subject(:dereg_service) { described_class.new(admin_team_user, registration) }

        let(:registration) do
          registration = create(:registration)
          registration.registration_exemptions.each do |re|
            re.state = "active"
            re.save!
          end
          registration
        end

        context "when the user has sufficient permissions" do
          context "when all of its registration_exemptions are active" do
            it "changes the state of the registration" do
              expect { dereg_service.deregister!(:revoke, deregistration_message) }
                .to change(registration, :state)
                .from("active")
                .to("revoked")
            end

            it "changes the state of all of the registration_exemptions" do
              registration.registration_exemptions.each do |re|
                expect(re.state).to eq("active")
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              registration.registration_exemptions.each do |re|
                re.reload
                expect(re.state).to eq("revoked")
              end
            end

            it "sets the deregistration_message for all of the registration_exemptions" do
              registration.registration_exemptions.each do |re|
                expect(re.deregistration_message).to be_nil
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              registration.registration_exemptions.each do |re|
                re.reload
                expect(re.deregistration_message).to eq(deregistration_message)
              end
            end

            it "creates a version for all of the registration_exemptions", :versioning do
              registration.registration_exemptions.each do |re|
                expect(re.versions.size).to eq(0)
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              registration.registration_exemptions.each do |re|
                expect(re.versions.size).to eq(1)
                expect(re.versions.first.whodunnit).to eq(admin_team_user.email)
              end
            end
          end

          context "when only some of its registration_exemptions are active" do
            subject(:dereg_service) { described_class.new(admin_team_user, registration) }

            let(:ceased_message) { "This exemption is ceased!" }
            let(:registration) do
              registration = create(:registration)
              registration_exemptions = registration.registration_exemptions.to_a
              reg_exemption = registration_exemptions.shift
              registration_exemptions.each do |re|
                re.cease!
                re.deregistered_at = 1.day.ago
                re.deregistration_message = ceased_message
                re.save!
              end
              reg_exemption.state = "active"
              reg_exemption.save!
              registration
            end
            let(:active_registration_exemptions) { registration.registration_exemptions.select(&:active?) }
            let(:inactive_registration_exemptions) { registration.registration_exemptions.select(&:ceased?) }

            it "changes the state of the registration" do
              expect { dereg_service.deregister!(:revoke, deregistration_message) }
                .to change(registration, :state)
                .from("active")
                .to("revoked")
            end

            it "changes the state of all of the active registration_exemptions" do
              active_registration_exemptions.each do |re|
                expect(re.state).to eq("active")
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              active_registration_exemptions.each do |re|
                re.reload
                expect(re.state).to eq("revoked")
              end
            end

            it "sets the deregistration_message for all of the active registration_exemptions" do
              active_registration_exemptions.each do |re|
                expect(re.deregistration_message).to be_nil
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              active_registration_exemptions.each do |re|
                re.reload
                expect(re.deregistration_message).to eq(deregistration_message)
              end
            end

            it "does not change the state of the inactive registration_exemptions" do
              inactive_registration_exemptions.each do |re|
                expect(re.state).to eq("ceased")
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              inactive_registration_exemptions.each do |re|
                re.reload
                expect(re.state).to eq("ceased")
              end
            end

            it "does not set the deregistration_message for all of the inactive registration_exemptions" do
              inactive_registration_exemptions.each do |re|
                expect(re.deregistration_message).to eq(ceased_message)
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              inactive_registration_exemptions.each do |re|
                re.reload
                expect(re.deregistration_message).to eq(ceased_message)
              end
            end
          end

          context "when the new state is 'pending'" do
            it "raises an error" do
              expect { dereg_service.deregister!(:pending, deregistration_message) }.to raise_error(NoMethodError)
            end
          end
        end

        context "when the user has insufficient permissions" do
          subject(:dereg_service) { described_class.new(data_viewer_user, registration) }

          it "does not change the state of the registration or any of its registration_exemptions" do
            expect { dereg_service.deregister!(:revoke, deregistration_message) }
              .not_to change(registration, :state)
              .from("active")
          end
        end
      end

      context "when the registration is not active" do
        subject(:dereg_service) { described_class.new(admin_team_user, registration) }

        let(:registration) do
          registration = create(:registration)
          registration.registration_exemptions.each(&:cease!)
          registration
        end

        context "when the user has sufficient permissions" do
          it "does not change the state of the registration or any of its registration_exemptions" do
            expect { dereg_service.deregister!(:revoke, deregistration_message) }
              .not_to change(registration, :state)
              .from("ceased")
          end
        end

        context "when the user has insufficient permissions" do
          subject(:dereg_service) { described_class.new(data_viewer_user, registration) }

          it "does not change the state of the registration or any of its registration_exemptions" do
            expect { dereg_service.deregister!(:revoke, deregistration_message) }
              .not_to change(registration, :state)
              .from("ceased")
          end
        end
      end
    end

    context "when the resource is a site (Address)" do
      context "when the site is active" do
        subject(:dereg_service) { described_class.new(admin_team_user, site) }

        let(:registration) { create(:registration, :multi_site, registration_exemptions: []) }
        let(:site) do
          site = registration.site_addresses.first
          site.registration_exemptions << create(:registration_exemption, state: "active")
          site.registration_exemptions << create(:registration_exemption, state: "active")
          site
        end

        context "when the user has sufficient permissions" do
          context "when all of site registration_exemptions are active" do
            it "changes the state of the site" do
              expect { dereg_service.deregister!(:revoke, deregistration_message) }
                .to change(site, :site_status)
                .from("active")
                .to("deregistered")
            end

            it "changes the state of all of the registration_exemptions" do
              site.registration_exemptions.each do |re|
                expect(re.state).to eq("active")
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              site.registration_exemptions.each do |re|
                re.reload
                expect(re.state).to eq("revoked")
              end
            end

            it "sets the deregistration_message for all of the registration_exemptions" do
              site.registration_exemptions.each do |re|
                expect(re.deregistration_message).to be_nil
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              site.registration_exemptions.each do |re|
                re.reload
                expect(re.deregistration_message).to eq(deregistration_message)
              end
            end

            it "creates a version for all of the registration_exemptions", :versioning do
              site.registration_exemptions.each do |re|
                expect(re.versions.size).to eq(0)
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              site.registration_exemptions.each do |re|
                expect(re.versions.size).to eq(1)
                expect(re.versions.first.whodunnit).to eq(admin_team_user.email)
              end
            end
          end

          context "when only some of site registration_exemptions are active" do
            subject(:dereg_service) { described_class.new(admin_team_user, site) }

            let(:ceased_message) { "This exemption is ceased!" }
            let(:active_registration_exemptions) { site.registration_exemptions.select(&:active?) }
            let(:inactive_registration_exemptions) { site.registration_exemptions.select(&:ceased?) }

            before do
              site.registration_exemptions.first.update(state: "ceased", deregistration_message: ceased_message, deregistered_at: 1.day.ago)
            end

            it "changes the state of the site" do
              expect { dereg_service.deregister!(:revoke, deregistration_message) }
                .to change(site, :site_status)
                .from("active")
                .to("deregistered")
            end

            it "changes the state of all of the active site registration_exemptions" do
              active_registration_exemptions.each do |re|
                expect(re.state).to eq("active")
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              active_registration_exemptions.each do |re|
                re.reload
                expect(re.state).to eq("revoked")
              end
            end

            it "sets the deregistration_message for all of the active site registration_exemptions" do
              active_registration_exemptions.each do |re|
                expect(re.deregistration_message).to be_nil
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              active_registration_exemptions.each do |re|
                re.reload
                expect(re.deregistration_message).to eq(deregistration_message)
              end
            end

            it "does not change the state of the inactive site registration_exemptions" do
              inactive_registration_exemptions.each do |re|
                expect(re.state).to eq("ceased")
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              inactive_registration_exemptions.each do |re|
                re.reload
                expect(re.state).to eq("ceased")
              end
            end

            it "does not set the deregistration_message for all of the inactive site registration_exemptions" do
              inactive_registration_exemptions.each do |re|
                expect(re.deregistration_message).to eq(ceased_message)
              end
              dereg_service.deregister!(:revoke, deregistration_message)
              inactive_registration_exemptions.each do |re|
                re.reload
                expect(re.deregistration_message).to eq(ceased_message)
              end
            end
          end

          context "when the new state is 'pending'" do
            it "raises an error" do
              expect { dereg_service.deregister!(:pending, deregistration_message) }.to raise_error(NoMethodError)
            end
          end
        end

        context "when the user has insufficient permissions" do
          subject(:dereg_service) { described_class.new(data_viewer_user, site) }

          it "does not change the state of the registration or any of its registration_exemptions" do
            expect { dereg_service.deregister!(:revoke, deregistration_message) }
              .not_to change(site, :site_status)
              .from("active")
          end
        end
      end
    end

    context "when the resource is a RegistrationExemption" do
      let(:active_registration_exemption) do
        reg_exemption = create(:registration).registration_exemptions.first
        reg_exemption.state = "active"
        reg_exemption
      end

      let(:last_active_registration_exemption) do
        registration_exemptions = create(:registration).registration_exemptions.to_a
        reg_exemption = registration_exemptions.shift
        registration_exemptions.each(&:revoke!)
        reg_exemption.state = "active"
        reg_exemption
      end

      let(:inactive_registration_exemption) do
        reg_exemption = create(:registration).registration_exemptions.first
        reg_exemption.state = "revoked"
        reg_exemption
      end

      context "when the registration_exemption is active" do
        context "when the user has sufficient permissions" do
          subject(:dereg_service) { described_class.new(admin_team_user, active_registration_exemption) }

          %i[revoke cease].each do |allowed_state|
            context "when the new state is '#{allowed_state}'" do
              it "changes the registration_exemption state" do
                expect { dereg_service.deregister!(allowed_state, deregistration_message) }
                  .to change(active_registration_exemption, :state)
                  .from("active")
                  .to("#{allowed_state}d") # simple past tense
              end

              it "sets the deregistration_message" do
                expect { dereg_service.deregister!(allowed_state, deregistration_message) }
                  .to change(active_registration_exemption, :deregistration_message)
                  .from(nil)
                  .to(deregistration_message)
              end
            end
          end

          context "when the new state is 'pending'" do
            it "raises an error" do
              expect { dereg_service.deregister!(:pending, deregistration_message) }.to raise_error(NoMethodError)
            end
          end

          context "when it is not the last registration_exemption to become inactive for the registration" do
            it "does not result in a change in the state for the registration" do
              expect(active_registration_exemption.registration.state).to eq("active")
              dereg_service.deregister!(:revoke, deregistration_message)
              active_registration_exemption.registration.reload
              expect(active_registration_exemption.registration.state).to eq("active")
            end
          end

          context "when it is the last registration_exemption to become inactive for the registration" do
            subject(:dereg_service) { described_class.new(admin_team_user, last_active_registration_exemption) }

            it "results in a change in the state for the registration" do
              expect(last_active_registration_exemption.registration.state).to eq("active")
              dereg_service.deregister!(:revoke, deregistration_message)
              last_active_registration_exemption.registration.reload
              expect(last_active_registration_exemption.registration.state).to eq("revoked")
            end
          end
        end

        context "when the user has insufficient permissions" do
          subject(:dereg_service) { described_class.new(data_viewer_user, active_registration_exemption) }

          it "does not change the registration_exemption state" do
            expect { dereg_service.deregister!(:revoke, deregistration_message) }
              .not_to change(active_registration_exemption, :state)
              .from("active")
          end
        end
      end

      context "when the registration_exemption is inactive" do
        context "when the user has sufficient permissions" do
          subject(:dereg_service) { described_class.new(admin_team_user, inactive_registration_exemption) }

          it "does not change the registration_exemption state" do
            expect { dereg_service.deregister!(:revoke, deregistration_message) }
              .not_to change(inactive_registration_exemption, :state)
              .from("revoked")
          end
        end

        context "when the user has insufficient permissions" do
          subject(:dereg_service) { described_class.new(data_viewer_user, inactive_registration_exemption) }

          it "does not change the registration_exemption state" do
            expect { dereg_service.deregister!(:revoke, deregistration_message) }
              .not_to change(inactive_registration_exemption, :state)
              .from("revoked")
          end
        end
      end
    end
  end
end
