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

    inactive_states.each do |inactive_state|
      context "when the state is #{inactive_state}" do
        before { registration_exemption.state = inactive_state }

        it "can not transition to any other status" do
          expect(permitted_states).to be_empty
        end
      end
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
end
