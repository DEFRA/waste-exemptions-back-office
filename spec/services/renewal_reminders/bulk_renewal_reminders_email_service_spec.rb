# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe BulkRenewalRemindersEmailService do

    describe ".run" do
      subject(:run_bulk_service) { described_class.run(reminder_sequence) }

      let(:reminder_sequence) { :first }
      let(:expires_on) { 4.weeks.from_now.to_date }

      let(:notify_client) { instance_double(Notifications::Client) }

      let(:t28_exemption) { create(:exemption, code: "T28") }

      let(:chargeable_registration) do
        create(:registration, business_type: "soleTrader",
                              registration_exemptions: [build(:registration_exemption, expires_on:)])
      end
      let(:charity_registration) do
        create(:registration, business_type: "charity",
                              registration_exemptions: [build(:registration_exemption, expires_on:)])
      end
      let(:t28_registration) do
        create(:registration,
               registration_exemptions: [build(:registration_exemption, exemption: t28_exemption, expires_on:)])
      end
      let(:expiring_non_active_registration) do
        create(:registration,
               registration_exemptions: [build(:registration_exemption, :revoked, expires_on:)])
      end
      let(:non_expiring_non_active_registration) do
        create(:registration,
               registration_exemptions: [build(:registration_exemption, :active, expires_on: 5.weeks.from_now.to_date)])
      end
      let(:blank_contact_email_registration) do
        create(:registration, contact_email: nil,
                              registration_exemptions: [build(:registration_exemption, :active, expires_on:)])
      end
      let(:ncc_postcode_registration) do
        create(:registration, :site_uses_address,
               addresses: [build(:address, :site_address, postcode: "S9 4WF")],
               registration_exemptions: [build(:registration_exemption, :active, expires_on:)])
      end

      before do
        allow(WasteExemptionsEngine.configuration).to receive(:renewal_window_before_expiry_in_days).and_return("28")
        allow(WasteExemptionsBackOffice::Application.config).to receive(:second_renewal_email_reminder_days).and_return("14")
        allow(Notifications::Client).to receive(:new).and_return notify_client
        allow(notify_client).to receive(:send_email)

        allow(Airbrake).to receive(:notify)

        chargeable_registration
        ncc_postcode_registration
        charity_registration
        t28_registration
      end

      context "when the email sending fails" do
        before { allow(notify_client).to receive(:send_email).and_raise("An error") }

        it "reports the error to Airbrake" do
          run_bulk_service

          expect(Airbrake).to have_received(:notify).at_least(:once)
        end
      end

      shared_examples "email sent to registration" do
        it "sends an email to the registration" do
          run_bulk_service

          expect(notify_client).to have_received(:send_email)
            .with(hash_including(email_address: registration.contact_email))
        end
      end

      shared_examples "first reminder email sent to registration" do
        let(:expires_on) { 4.weeks.from_now.to_date }

        it_behaves_like "email sent to registration"
      end

      shared_examples "second reminder email sent to registration" do
        let(:expires_on) { 2.weeks.from_now.to_date }

        it_behaves_like "email sent to registration"
      end

      shared_examples "email not sent to registration" do
        it "does not send an email to the specified registration" do
          expect(notify_client).not_to have_received(:send_email)
            .with(hash_including(email_address: registration.contact_email))
        end
      end

      shared_examples "does not send to non-qualifying registrations" do
        it_behaves_like "email not sent to registration" do
          let(:registration) { expiring_non_active_registration }
        end
        it_behaves_like "email not sent to registration" do
          let(:registration) { non_expiring_non_active_registration }
        end
        it_behaves_like "email not sent to registration" do
          let(:registration) { blank_contact_email_registration }
        end
      end

      context "with the first reminder date" do
        let(:reminder_sequence) { :first }

        it_behaves_like "first reminder email sent to registration" do
          let(:registration) { chargeable_registration }
        end

        # AD registrations need a different template_id
        it_behaves_like "first reminder email sent to registration" do
          let(:registration) { ncc_postcode_registration }
        end

        it_behaves_like "first reminder email sent to registration" do
          let(:registration) { charity_registration }
        end

        it_behaves_like "first reminder email sent to registration" do
          let(:registration) { t28_registration }
        end

        it_behaves_like "does not send to non-qualifying registrations" do
          let(:expires_on) { 4.weeks.from_now.to_date }
        end
      end

      context "with the second reminder date" do
        let(:reminder_sequence) { :second }

        it_behaves_like "second reminder email sent to registration" do
          let(:registration) { chargeable_registration }
        end

        # AD registrations need a different template_id
        it_behaves_like "second reminder email sent to registration" do
          let(:registration) { chargeable_registration }
        end

        it_behaves_like "second reminder email sent to registration" do
          let(:registration) { charity_registration }
        end

        it_behaves_like "second reminder email sent to registration" do
          let(:registration) { t28_registration }
        end

        it_behaves_like "does not send to non-qualifying registrations" do
          let(:expires_on) { 2.weeks.from_now.to_date }
        end
      end
    end
  end
end
