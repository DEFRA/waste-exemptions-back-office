# frozen_string_literal: true

require "rails_helper"

module RenewalReminders
  RSpec.describe BulkRenewalLettersService do
    describe ".run" do
      before do
        allow(RenewalLetterService).to receive(:run)
        allow(Airbrake).to receive(:notify)
      end

      let!(:blank_email_registration) { create_list(:registration, 2, :has_no_email) }
      let!(:registration_with_email) { create(:registration) }
      let!(:non_matching_date_registration) { create(:registration, :has_no_email, :expires_tomorrow) }
      let!(:inactive_registration) { create(:registration, :has_no_email, :with_ceased_exemptions) }

      let(:expires_on) { blank_email_registration.first.registration_exemptions.first.expires_on }

      let!(:expires_29_days_registration) do
        create(:registration, :has_no_email,
               registration_exemptions: build_list(:registration_exemption, 3, expires_on: expires_on - 1.day))
      end
      let!(:expires_30_days_registration) do
        create(:registration, :has_no_email,
               registration_exemptions: build_list(:registration_exemption, 3, expires_on: expires_on))
      end
      let!(:expires_31_days_registration) do
        create(:registration, :has_no_email,
               registration_exemptions: build_list(:registration_exemption, 3, expires_on: expires_on + 1.day))
      end

      it "sends the relevant registrations to the RenewalLetterService" do
        described_class.run(expires_on)

        expect(Airbrake).not_to have_received(:notify)

        expect(RenewalLetterService).to have_received(:run).with(registration: blank_email_registration[0])
        expect(RenewalLetterService).to have_received(:run).with(registration: blank_email_registration[1])

        expect(RenewalLetterService).not_to have_received(:run).with(registration: registration_with_email)
        expect(RenewalLetterService).not_to have_received(:run).with(registration: non_matching_date_registration)
        expect(RenewalLetterService).not_to have_received(:run).with(registration: inactive_registration)
      end

      it "sends only registrations which expire in exactly 30 days" do
        described_class.run(expires_on)

        expect(Airbrake).not_to have_received(:notify)

        expect(RenewalLetterService).not_to have_received(:run).with(registration: expires_29_days_registration)
        expect(RenewalLetterService).to have_received(:run).with(registration: expires_30_days_registration)
        expect(RenewalLetterService).not_to have_received(:run).with(registration: expires_31_days_registration)
      end

      context "when an error happens" do
        before { allow(RenewalLetterService).to receive(:run).with(registration: blank_email_registration[0]).and_raise("An error") }

        it "notifies Airbrake without failing the whole job" do
          expect { described_class.run(expires_on) }.not_to raise_error

          expect(RenewalLetterService).to have_received(:run).with(registration: blank_email_registration[0])
          expect(Airbrake).to have_received(:notify).once
          expect(RenewalLetterService).to have_received(:run).with(registration: blank_email_registration[1])
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
end
