# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdPrivacyPolicyHelper do

  describe "destination_path" do
    context "when a registration is present" do
      before { @registration = build(:registration) }

      # rubocop:disable RSpec/InstanceVariable -- the helper checks for an instance variable
      it "returns the renewal path for the registration" do
        expect(helper.destination_path).to eq renew_path(reference: @registration.reference)
      end
      # rubocop:enable RSpec/InstanceVariable
    end

    context "when no registration is present" do
      context "when the back_office_private_beta_link feature toggle is not enabled" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?)
            .with(:back_office_private_beta_link).and_return(false)
        end

        it "returns the non-charged new registration start path" do
          expect(helper.destination_path).to eq WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path
        end
      end

      context "when the back_office_private_beta_link feature toggle is enabled" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?)
            .with(:back_office_private_beta_link).and_return(true)
        end

        it "creates a new charged registration" do
          expect { helper.destination_path }.to change(WasteExemptionsEngine::NewChargedRegistration, :count).by(1)
        end

        it "returns the path to the location page" do
          destination_path = helper.destination_path
          transient_registration = WasteExemptionsEngine::NewChargedRegistration.last
          expect(destination_path).to eq WasteExemptionsEngine::Engine
            .routes.url_helpers
            .new_location_form_path(transient_registration.token)
        end
      end
    end
  end
end
