# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe BulkFreeRenewalRemindersService do
    let(:t28_exemption) { create(:exemption, code: "T28") }

    before do
      allow(WasteExemptionsEngine.configuration).to receive(:renewal_window_before_expiry_in_days).and_return("28")
    end

    describe ".run" do

      before do
        allow(FreeRenewalReminderEmailService).to receive(:run)
        allow(Airbrake).to receive(:notify)
      end

      context "when the email sending fails" do

        before { allow(FreeRenewalReminderEmailService).to receive(:run).and_raise("An error") }

        it "reports the error to Airbrake" do
          create(
            :registration,
            business_type: "charity",
            registration_exemptions: [
              build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date)
            ]
          )

          described_class.run

          expect(FreeRenewalReminderEmailService).to have_received(:run)
          expect(Airbrake).to have_received(:notify)
        end
      end

      it "sends a renewal email to qualifying active registrations due to expire in 4 weeks" do
        active_expiring_not_free_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        active_expiring_charity_registration = create(
          :registration,
          business_type: "charity",
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        active_expiring_t28_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, exemption: t28_exemption, expires_on: 4.weeks.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        active_expiring_charity_t28_registration = create(
          :registration,
          business_type: "charity",
          registration_exemptions: [
            build(:registration_exemption, :active, exemption: t28_exemption, expires_on: 4.weeks.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        expiring_non_active_not_free_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        expiring_non_active_charity_registration = create(
          :registration,
          business_type: "charity",
          registration_exemptions: [
            build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        expiring_non_active_t28_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :revoked, exemption: t28_exemption, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        non_expiring_non_active_not_free_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 5.weeks.from_now.to_date)
          ]
        )

        non_expiring_non_active_charity_registration = create(
          :registration,
          business_type: "charity",
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 5.weeks.from_now.to_date)
          ]
        )

        non_expiring_non_active_t28_registration = create(
          :registration,
          registration_exemptions: [
            build(:registration_exemption, :active, exemption: t28_exemption, expires_on: 5.weeks.from_now.to_date)
          ]
        )

        described_class.run

        expect(FreeRenewalReminderEmailService).not_to have_received(:run).with(registration: active_expiring_not_free_registration)
        expect(FreeRenewalReminderEmailService).to have_received(:run).with(registration: active_expiring_charity_registration)
        expect(FreeRenewalReminderEmailService).to have_received(:run).with(registration: active_expiring_t28_registration)
        expect(FreeRenewalReminderEmailService).to have_received(:run).with(registration: active_expiring_charity_t28_registration).once
        expect(FreeRenewalReminderEmailService).not_to have_received(:run).with(registration: expiring_non_active_not_free_registration)
        expect(FreeRenewalReminderEmailService).not_to have_received(:run).with(registration: expiring_non_active_charity_registration)
        expect(FreeRenewalReminderEmailService).not_to have_received(:run).with(registration: expiring_non_active_t28_registration)
        expect(FreeRenewalReminderEmailService).not_to have_received(:run).with(registration: non_expiring_non_active_not_free_registration)
        expect(FreeRenewalReminderEmailService).not_to have_received(:run).with(registration: non_expiring_non_active_charity_registration)
        expect(FreeRenewalReminderEmailService).not_to have_received(:run).with(registration: non_expiring_non_active_t28_registration)
      end

      it "does not send emails to blank email addresses" do
        create(
          :registration,
          business_type: "charity",
          contact_email: nil,
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date),
            build(:registration_exemption, :revoked, expires_on: 4.weeks.from_now.to_date)
          ]
        )

        described_class.run

        expect(FreeRenewalReminderEmailService).not_to have_received(:run)
      end

      it "does not send emails to registrations with the NCCC postcode" do
        registration = create(
          :registration,
          :site_uses_address,
          business_type: "charity",
          registration_exemptions: [
            build(:registration_exemption, :active, expires_on: 4.weeks.from_now.to_date)
          ]
        )
        registration.site_address.update(postcode: "S9 4WF")

        described_class.run

        expect(FreeRenewalReminderEmailService).not_to have_received(:run)
      end
    end
  end
end
