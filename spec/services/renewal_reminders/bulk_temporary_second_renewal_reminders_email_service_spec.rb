# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe BulkTemporarySecondRenewalRemindersEmailService do
    before do
      allow(WasteExemptionsBackOffice::Application.config).to receive(:second_renewal_email_reminder_days).and_return("14")
    end

    describe ".run" do

      before do
        allow(TemporarySecondRenewalReminderEmailService).to receive(:run)
        allow(Airbrake).to receive(:notify)
      end

      context "when the email sending fails" do

        before { allow(TemporarySecondRenewalReminderEmailService).to receive(:run).and_raise("An error") }

        it "reports the error to Airbrake" do
          create(
            :registration,
            registration_exemptions: [
              build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date)
            ]
          )

          described_class.run

          expect(TemporarySecondRenewalReminderEmailService).to have_received(:run)
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
            build(:registration_exemption, :active, expires_on: 3.weeks.from_now.to_date)
          ]
        )

        described_class.run

        expect(TemporarySecondRenewalReminderEmailService).to have_received(:run).with(registration: active_expiring_registration).at_least(:once)
        expect(TemporarySecondRenewalReminderEmailService).not_to have_received(:run).with(registration: expiring_non_active_registration)
        expect(TemporarySecondRenewalReminderEmailService).not_to have_received(:run).with(registration: non_expiring_non_active_registration)
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

        expect(TemporarySecondRenewalReminderEmailService).not_to have_received(:run)
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

        expect(TemporarySecondRenewalReminderEmailService).not_to have_received(:run)
      end

      it "does not send emails to registrations that have been renewed in the last month" do
        active_expiring_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 2.weeks.from_now.to_date)
          ]
        )

        # Create a renewal registration manually instead of using the :has_been_renewed trait
        create(
          :registration,
          submitted_at: 2.weeks.ago,
          referring_registration_id: active_expiring_registration.id,
          registration_exemptions: [
            build(:registration_exemption, :active)
          ]
        )

        allow(WasteExemptionsEngine::Registration).to receive(:renewals).and_return(
          WasteExemptionsEngine::Registration.where(referring_registration_id: active_expiring_registration.id)
        )

        described_class.run

        expect(TemporarySecondRenewalReminderEmailService).not_to have_received(:run)
      end
    end
  end
end
