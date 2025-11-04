# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe FinalRenewalReminderTextService do
    describe "#run" do
      subject(:run_service) { described_class.run(registration: registration) }

      let(:registration) { create(:registration, :with_valid_mobile_phone_number) }
      let(:notifications_client) { instance_double(Notifications::Client) }

      before do
        allow(Notifications::Client).to receive(:new).and_return(notifications_client)
        allow(notifications_client).to receive(:send_sms)
      end

      context "when registration phone number is valid" do

        shared_examples "sends a text with the correct template" do
          before { run_service }

          it do
            expect(notifications_client).to have_received(:send_sms)
              .with(hash_including(
                      phone_number: registration.contact_phone,
                      template_id: "7d101a7d-9678-464e-a57d-e18714afbc5d"
                    ))
          end
        end

        context "when the registration is not assisted digital" do
          before { registration.site_address.update(postcode: "AA1 1AA") }

          it_behaves_like "sends a text with the correct template"
        end

        # AD registrations were previously excluded by the bulk service.
        # This spec is to ensure there is inadvertent exclusion.
        context "when the registration is assisted digital" do
          before { registration.site_address.update(postcode: "S9 4WF") }

          it_behaves_like "sends a text with the correct template"
        end

        it "creates a communication log" do
          run_service
          log = registration.communication_logs.last
          expect(log).to have_attributes(
            message_type: "text",
            template_label: "Final renewal reminder text",
            sent_to: registration.contact_phone
          )
        end
      end

      context "when registration phone number is not valid" do
        it "returns early when contact_phone is empty" do
          registration.update(contact_phone: nil)
          run_service
          expect(notifications_client).not_to have_received(:send_sms)
        end

        it "returns early when contact_phone is not a valid mobile phone" do
          registration.update(contact_phone: "0123456789")
          run_service
          expect(notifications_client).not_to have_received(:send_sms)
        end
      end

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:parameters) { { registration: create(:registration, :with_valid_mobile_phone_number) } }
      end
    end
  end
end
