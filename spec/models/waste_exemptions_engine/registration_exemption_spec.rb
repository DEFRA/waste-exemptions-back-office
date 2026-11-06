# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::RegistrationExemption do
  subject(:registration_exemption) { build(:registration).registration_exemptions.first }

  let(:permitted_states) { registration_exemption.aasm.states(permitted: true).map(&:name) }

  deregistration_states = %i[cease revoke]
  transitions = deregistration_states + [:expire]
  inactive_states = %i[ceased revoked expired]

  describe "exemption state" do
    context "when the state is 'active'" do
      before do
        registration_exemption.state = :active
        registration_exemption.deregistered_at = nil
      end

      it "can transition to any of the inactive states" do
        expect(permitted_states).to match_array(inactive_states)
      end

      transitions.zip(inactive_states).each do |transition, expected_state|
        context "when the '#{transition}' transition is executed" do
          it "reflects the correct state" do
            expect { registration_exemption.send("#{transition}!") }
              .to change(registration_exemption, :state)
              .from("active")
              .to(expected_state.to_s)
          end

          if deregistration_states.include? transition
            it "updates the deregistered_at time stamp" do
              expect { registration_exemption.send("#{transition}!") }
                .to change(registration_exemption, :deregistered_at)
                .from(nil)
                .to(Time.zone.today)
            end
          else
            it "does not update the deregistered_at time stamp" do
              expect { registration_exemption.send("#{transition}!") }
                .not_to change(registration_exemption, :deregistered_at)
                .from(nil)
            end
          end
        end
      end
    end

    %i[ceased revoked].each do |deregistered_state|
      context "when the state is #{deregistered_state}" do
        before { registration_exemption.state = deregistered_state }

        it "can only transition back to active" do
          expect(permitted_states).to contain_exactly(:active)
        end
      end
    end

    context "when the state is expired" do
      before { registration_exemption.state = :expired }

      it "can not transition to any other status" do
        expect(permitted_states).to be_empty
      end
    end
  end

  describe ".current" do
    let(:registration) { create(:registration, registration_exemptions: []) }

    it "returns active exemptions that have not expired" do
      registration_exemption = create(:registration_exemption, :active, registration:)

      expect(described_class.current).to include(registration_exemption)
    end

    it "returns active exemptions that expire today" do
      registration_exemption = create(:registration_exemption, :active, registration:, expires_on: Time.zone.today)

      expect(described_class.current).to include(registration_exemption)
    end

    it "does not return active exemptions past their expiry date" do
      registration_exemption = create(:registration_exemption, :active, registration:,
                                                                        expires_on: Time.zone.yesterday)

      expect(described_class.current).not_to include(registration_exemption)
    end

    it "does not return exemptions that are no longer active" do
      registration_exemption = create(:registration_exemption, :ceased, registration:)

      expect(described_class.current).not_to include(registration_exemption)
    end
  end

  describe "#renewal" do
    subject(:registration_exemption) { registration.registration_exemptions.first }

    context "without a referring registration" do
      let(:registration) { build(:registration) }

      it "returns false" do
        expect(registration_exemption.renewal).to be false
      end
    end

    context "with a referring registration" do
      let(:registration) { build(:registration, referring_registration: build(:registration)) }

      it "returns true" do
        expect(registration_exemption.renewal).to be true
      end
    end
  end

  describe "PaperTrail", :versioning do
    before { registration_exemption.save! }

    it "is versioned" do
      expect(registration_exemption).to be_versioned
    end

    context "when revoking a registration exemption" do
      it "creates a new version" do
        expect { registration_exemption.revoke! }.to change { registration_exemption.versions.count }.by(1)
        expect(registration_exemption.versions.first.reify.state).to eq("active")
        expect(registration_exemption.versions.first.reify.deregistered_at).to be_nil
        expect(registration_exemption.reload.deregistered_at).not_to be_nil
      end
    end

    context "when ceasing a registration exemption" do
      it "creates a new version" do
        expect { registration_exemption.cease! }.to change { registration_exemption.versions.count }.by(1)
        expect(registration_exemption.versions.first.reify.state).to eq("active")
        expect(registration_exemption.versions.first.reify.deregistered_at).to be_nil
        expect(registration_exemption.reload.deregistered_at).not_to be_nil
      end
    end

    context "when performing a regular update" do
      before do
        registration_exemption.update!(deregistration_message: "foo")
      end

      it "does not create a new version" do
        expect(registration_exemption.versions.size).to eq(0)
      end
    end
  end

  describe "#deregistered_by", :versioning do
    let(:user) { create(:user, email: "user@example.com") }
    let(:registration_exemption) { create(:registration_exemption, state: "active") }

    context "when state is changed to ceased" do
      before do
        PaperTrail.request(whodunnit: user.email) do
          registration_exemption.cease!
        end
      end

      it "returns the email of the user who changed the state to ceased" do
        expect(registration_exemption.deregistered_by).to eq(user.email)
      end
    end

    context "when state is changed to revoked" do
      before do
        PaperTrail.request(whodunnit: user.email) do
          registration_exemption.revoke!
        end
      end

      it "returns the email of the user who changed the state to revoked" do
        expect(registration_exemption.deregistered_by).to eq(user.email)
      end
    end

    context "when state is changed to a state other than ceased or revoked" do
      before do
        PaperTrail.request(whodunnit: user.email) do
          registration_exemption.update!(state: "expired")
        end
      end

      it "does not return any email" do
        expect(registration_exemption.deregistered_by).to be_nil
      end
    end

    context "when multiple state changes occur" do
      let(:another_user) { create(:user, email: "nother_user@example.com") }

      before do
        PaperTrail.request(whodunnit: user.email) do
          registration_exemption.update!(state: "expired")
        end

        PaperTrail.request(whodunnit: user.email) do
          registration_exemption.update!(state: "active")
        end

        PaperTrail.request(whodunnit: another_user.email) do
          registration_exemption.revoke!
        end
      end

      it "returns the email of the user who last changed the state to ceased or revoked" do
        expect(registration_exemption.deregistered_by).to eq(another_user.email)
      end
    end
  end

  describe "#restorable?" do
    %w[ceased revoked].each do |state|
      context "when the registration_exemption is #{state}" do
        it { expect(build(:registration_exemption, state: state)).to be_restorable }
      end
    end

    %w[active expired].each do |state|
      context "when the registration_exemption is #{state}" do
        it { expect(build(:registration_exemption, state: state)).not_to be_restorable }
      end
    end
  end

  describe "#restore!" do
    subject(:registration_exemption) do
      create(:registration_exemption, state: "revoked", deregistered_at: 1.day.ago,
                                      deregistration_message: "Did not pay", deregistered_by: "someone@example.com")
    end

    it "makes the registration_exemption active again and clears the deregistration details" do
      registration_exemption.restore!
      registration_exemption.reload

      expect(registration_exemption.state).to eq("active")
      expect(registration_exemption.deregistered_at).to be_nil
      expect(registration_exemption.deregistration_message).to be_nil
      expect(registration_exemption[:deregistered_by]).to be_nil
    end
  end
end
