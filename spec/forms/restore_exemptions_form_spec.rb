# frozen_string_literal: true

require "rails_helper"

RSpec.describe RestoreExemptionsForm, type: :model do
  subject(:form) { described_class.new }

  let(:admin_team_user) { build(:user, :admin_team_user) }
  let(:revoked_registration_exemption) do
    reg_exemption = build(:registration).registration_exemptions.first
    reg_exemption.state = "revoked"
    reg_exemption
  end
  let(:restoration_service) { RestorationService.new(admin_team_user, revoked_registration_exemption) }

  describe "validations" do
    subject(:validators) { form._validators }

    it "validates the message using the RestorationMessageValidator class" do
      expect(validators.keys).to include(:message)
      expect(validators[:message].first.class)
        .to eq(RestorationMessageValidator)
    end
  end

  describe "#submit" do
    context "when the form is valid" do
      it "submits" do
        good_params = { message: "This registration was deregistered in error" }
        expect(form.submit(good_params, restoration_service)).to be(true)
      end
    end

    context "when the form is not valid" do
      it "does not submit" do
        bad_params = { message: Helpers::TextGenerator.random_string(501) }
        expect(form.submit(bad_params, restoration_service)).to be(false)
      end
    end
  end
end
