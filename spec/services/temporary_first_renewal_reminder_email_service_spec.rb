# frozen_string_literal: true

require "rails_helper"

RSpec.describe TemporaryFirstRenewalReminderEmailService do
  describe ".run" do
    let(:registration) { create(:registration, :with_active_exemptions) }

    it "sends an email with the correct template" do
      VCR.use_cassette("temporary_first_renewal_reminder_email") do
        expect(described_class.run(registration: registration)).to be_a(Notifications::Client::ResponseNotification)
      end
    end

    it "creates a communication log" do
      VCR.use_cassette("temporary_first_renewal_reminder_email") do
        expect { described_class.run(registration: registration) }
          .to change { registration.communication_logs.count }.by(1)
      end
    end

    it "uses the correct template ID" do
      service = described_class.new
      expect(service.send(:template)).to eq("5a4f6146-1952-4e62-9824-ab5d0bd9a978")
    end

    it "includes a registration URL instead of a renewal link" do
      service = described_class.new
      service.instance_variable_set(:@registration, registration)

      personalisation = service.send(:personalisation)

      expect(personalisation[:magic_link_url]).to include("start")
      expect(personalisation[:magic_link_url]).not_to include("renew")
    end
  end
end
