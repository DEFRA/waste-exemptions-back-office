# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendRegistrationConfirmationWhenBalanceFullyPaidJob do

  let(:registration) { create(:registration, account: account, contact_email: contact_email) }
  let(:account) { create(:account, balance: balance) }
  let(:contact_email) { Faker::Internet.email }

  describe "#perform" do
    subject(:run_job) { described_class.new.perform(reference: registration.reference) }

    let(:notifications_client) { instance_double(Notifications::Client) }
    let(:confirmation_email_log) { create(:communication_log, template_id: SendRegistrationConfirmationWhenBalanceFullyPaidJob::REGISTRATION_COMPLETION_EMAIL_TEMPLATE_ID) }

    before do
      allow(WasteExemptionsEngine::ConfirmationEmailService).to receive(:run).with(anything).and_call_original
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(WasteExemptionsEngine::AccountBalanceService).to receive(:run).and_return(balance)
      allow(notifications_client).to receive(:send_email)
    end

    context "when the account balance is negative" do
      let(:balance) { -100 }

      it "does not send a confirmation email" do
        run_job
        expect(WasteExemptionsEngine::ConfirmationEmailService).not_to have_received(:run)
      end
    end

    context "when the account balance is equal or greater than 0" do
      let(:balance) { 0 }

      context "when the confirmation email has already been sent" do
        before do
          registration.communication_logs << confirmation_email_log
        end

        it "does not send a confirmation email" do
          run_job
          expect(WasteExemptionsEngine::ConfirmationEmailService).not_to have_received(:run)
        end
      end

      context "when the confirmation email has not been sent" do
        it "sends a confirmation email" do
          run_job
          expect(WasteExemptionsEngine::ConfirmationEmailService).to have_received(:run).with(registration: registration, recipient: registration.contact_email)
        end
      end

      context "when the contact email is blank" do
        let(:contact_email) { nil }

        it "does not send a confirmation email" do
          run_job
          expect(WasteExemptionsEngine::ConfirmationEmailService).not_to have_received(:run)
        end
      end

      context "when an error occurs" do
        before do
          allow(Airbrake).to receive(:notify)
          allow(Rails.logger).to receive(:error)
          allow(WasteExemptionsEngine::ConfirmationEmailService).to receive(:run).and_raise(StandardError.new("Test error"))
        end

        it "logs the response" do
          run_job
          expect(Rails.logger).to have_received(:error).with("Confirmation email error: Test error")
        end

        it "notifies Airbrake" do
          run_job
          expect(Airbrake).to have_received(:notify).with(StandardError, hash_including(reference: registration.reference))
        end
      end
    end
  end
end
