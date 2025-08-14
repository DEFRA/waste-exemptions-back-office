# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe FinalRenewalReminderService do
    before do
      allow(FinalRenewalReminderTextService).to receive(:run)
      allow(WasteExemptionsBackOffice::Application.config).to receive(:final_renewal_text_reminder_days).and_return("7")
      allow(Airbrake).to receive(:notify)
    end

    describe ".run" do
      context "when the text sending fails" do

        before { allow(FinalRenewalReminderTextService).to receive(:run).and_raise("An error") }

        it "report the error in the log and with Airbrake" do
          create(
            :registration,
            :with_valid_mobile_phone_number,
            registration_exemptions: [
              build(:registration_exemption, :active, expires_on: 1.week.from_now.to_date)
            ]
          )

          described_class.run

          expect(Airbrake).to have_received(:notify)
        end
      end

      it "send a final renewal text to all active registrations due to expire in 1 week" do
        active_expiring_registration = create(
          :registration,
          :with_valid_mobile_phone_number,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 1.week.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 1.week.from_now.to_date)
          ]
        )

        # Create an expiring registration in a non-active status. Make sure we don't pick it up and send an email.
        expiring_non_active_registration = create(
          :registration,
          :with_valid_mobile_phone_number,
          registration_exemptions: [
            build(:registration_exemption, :revoked, expires_on: 2.weeks.from_now.to_date)
          ]
        )

        # Create a non-expiring registration in a non-active status. Make sure we don't pick it up and send an email.
        non_expiring_non_active_registration = create(
          :registration,
          :with_valid_mobile_phone_number,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 5.weeks.from_now.to_date)
          ]
        )

        described_class.run

        expect(FinalRenewalReminderTextService).to have_received(:run).with(registration: active_expiring_registration)
        expect(FinalRenewalReminderTextService).not_to have_received(:run).with(registration: expiring_non_active_registration)
        expect(FinalRenewalReminderTextService).not_to have_received(:run).with(registration: non_expiring_non_active_registration)
      end

      it "do not send texts if a registration have already been renewed" do
        registration = create(
          :registration,
          :with_valid_mobile_phone_number,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 1.week.from_now.to_date)
          ]
        )

        create(:registration, referring_registration: registration)

        described_class.run

        expect(FinalRenewalReminderTextService).not_to have_received(:run)
      end

      it "do not send texts to blank/non-mobile phone numbers" do
        create(
          :registration,
          contact_phone: nil,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 1.week.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 1.week.from_now.to_date)
          ]
        )

        described_class.run

        expect(FinalRenewalReminderTextService).not_to have_received(:run)
      end

      it "does not send texts to registrations with the NCCC postcode" do
        registration = create(
          :registration,
          :site_uses_address,
          :with_valid_mobile_phone_number,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 1.week.from_now.to_date)
          ]
        )
        registration.site_address.update(postcode: "S9 4WF")

        described_class.run

        expect(FinalRenewalReminderTextService).not_to have_received(:run)
      end
    end
  end
end
