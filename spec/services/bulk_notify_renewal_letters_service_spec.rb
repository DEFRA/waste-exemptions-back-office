# frozen_string_literal: true

require "rails_helper"

RSpec.describe BulkNotifyRenewalLettersService do
  describe ".run" do
    let(:blank_email_registration) { create_list(:registration, 2, :has_no_email) }
    let(:registration_with_email) { create(:registration) }
    let(:non_matching_date_registration) { create(:registration, :has_no_email, :expires_tomorrow) }
    let(:inactive_registration) { create(:registration, :has_no_email, :with_ceased_exemptions) }

    let(:expires_on) { blank_email_registration.first.registration_exemptions.first.expires_on }

    let(:expires_29_days_registration) do
      create(:registration, :has_no_email,
             registration_exemptions: build_list(:registration_exemption, 3, expires_on: expires_on - 1.day))
    end
    let(:expires_30_days_registration) do
      create(:registration, :has_no_email,
             registration_exemptions: build_list(:registration_exemption, 3, expires_on: expires_on))
    end
    let(:expires_31_days_registration) do
      create(:registration, :has_no_email,
             registration_exemptions: build_list(:registration_exemption, 3, expires_on: expires_on + 1.day))
    end

    it "sends the relevant registrations to the NotifyRenewalLetterService" do
      expect(Airbrake).to_not receive(:notify)

      expect(NotifyRenewalLetterService).to receive(:run).with(registration: blank_email_registration[0])
      expect(NotifyRenewalLetterService).to receive(:run).with(registration: blank_email_registration[1])

      expect(NotifyRenewalLetterService).to_not receive(:run).with(registration: registration_with_email)
      expect(NotifyRenewalLetterService).to_not receive(:run).with(registration: non_matching_date_registration)
      expect(NotifyRenewalLetterService).to_not receive(:run).with(registration: inactive_registration)

      described_class.run(expires_on)
    end

    it "sends only registrations which expire in exactly 30 days" do
      expect(Airbrake).to_not receive(:notify)

      expect(NotifyRenewalLetterService).to_not receive(:run).with(registration: expires_29_days_registration)
      expect(NotifyRenewalLetterService).to receive(:run).with(registration: expires_30_days_registration)
      expect(NotifyRenewalLetterService).to_not receive(:run).with(registration: expires_31_days_registration)

      described_class.run(expires_on)
    end

    context "when an error happens" do
      it "notifies Airbrake without failing the whole job" do
        expect(NotifyRenewalLetterService).to receive(:run).with(registration: blank_email_registration[0]).and_raise("An error")
        expect(Airbrake).to receive(:notify).once
        expect(NotifyRenewalLetterService).to receive(:run).with(registration: blank_email_registration[1])

        expect { described_class.run(expires_on) }.to_not raise_error
      end
    end

    context "when there are no registrations" do
      let(:expires_on) { 500.years.ago }

      it "returns a result" do
        expect(described_class.run(expires_on)).to eq([])
      end
    end
  end
end
