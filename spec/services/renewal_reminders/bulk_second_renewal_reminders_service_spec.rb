# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe BulkSecondRenewalRemindersService do
    before do
      allow(SecondRenewalReminderEmailService).to receive(:run)
      allow(WasteExemptionsBackOffice::Application.config).to receive(:second_renewal_email_reminder_days).and_return("14")
      allow(Airbrake).to receive(:notify)
    end

    describe ".run" do
      context "when the email sending fails" do

        before { allow(SecondRenewalReminderEmailService).to receive(:run).and_raise("An error") }

        it "report the error in the log and with Airbrake" do
          create(
            :registration,
            registration_exemptions: [
              build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date)
            ]
          )

          described_class.run

          expect(Airbrake).to have_received(:notify)
        end
      end

      it "sends a second renewal email to all active registrations due to expire in 2 weeks" do
        active_expiring_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 2.weeks.from_now.to_date)
          ]
        )

        # Create an expiring registration in a non-active status. Make sure we don't pick it up and send an email.
        expiring_non_active_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :revoked, expires_on: 2.weeks.from_now.to_date)
          ]
        )

        # Create a non-expiring registration in a non-active status. Make sure we don't pick it up and send an email.
        non_expiring_non_active_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 5.weeks.from_now.to_date)
          ]
        )

        described_class.run

        expect(SecondRenewalReminderEmailService).to have_received(:run).with(registration: active_expiring_registration).at_least(:once)
        expect(SecondRenewalReminderEmailService).not_to have_received(:run).with(registration: expiring_non_active_registration)
        expect(SecondRenewalReminderEmailService).not_to have_received(:run).with(registration: non_expiring_non_active_registration)
      end

      it "does not send emails if a registration has already been renewed" do
        registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date)
          ]
        )

        create(:registration, referring_registration: registration)

        described_class.run

        expect(SecondRenewalReminderEmailService).not_to have_received(:run)
      end

      it "does not send emails to blank email addresses" do
        create(
          :registration,
          contact_email: nil,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 2.weeks.from_now.to_date)
          ]
        )

        described_class.run

        expect(SecondRenewalReminderEmailService).not_to have_received(:run)
      end

      it "does not send emails to registrations with the NCCC postcode" do
        registration = create(
          :registration,
          :site_uses_address,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date)
          ]
        )
        registration.site_address.update(postcode: "S9 4WF")

        described_class.run

        expect(SecondRenewalReminderEmailService).not_to have_received(:run)
      end

      it_behaves_like "excludes free renewals", described_class, SecondRenewalReminderEmailService, 2.weeks.from_now.to_date
    end
  end
end
