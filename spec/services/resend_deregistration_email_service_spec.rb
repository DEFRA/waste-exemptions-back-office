# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResendDeregistrationEmailService do
  include ActiveJob::TestHelper

  describe "run" do
    subject(:run_service) { described_class.run(registration: registration) }

    let(:registration) { create(:registration) }
    let(:deregistration_comms_label) { I18n.t("template_labels.deregistration_invitation_email") }
    let(:notifications_client) { instance_double(Notifications::Client) }

    before do
      # The dereg email should have been sent previously
      Timecop.freeze(1.week.ago) { registration.communication_logs << create(:communication_log, template_label: deregistration_comms_label) }
      allow(Notifications::Client).to receive(:new).and_return(notifications_client)
      allow(notifications_client).to receive(:send_email)
      allow(Airbrake).to receive(:notify)
    end

    after { Timecop.return }

    context "when successful" do
      it "resets the deregistration email communications history" do
        perform_enqueued_jobs { run_service }

        expect(registration.reload.communication_logs.find { |c| c.template_label == deregistration_comms_label }.created_at)
          .to be_within(2.seconds).of(Time.zone.now)
      end

      it "enqueues a job to send a deregistration email" do
        run_service

        expect(SendDeregistrationEmailJob).to have_been_enqueued.exactly(1)
      end

      it "returns a truthy result" do
        expect(run_service).to be_truthy
      end
    end

    context "when unsuccessful" do
      let(:error) { StandardError.new("foo") }

      before do
        allow(SendDeregistrationEmailJob).to receive(:perform_later).and_raise(error)
      end

      it "returns a falsey result" do
        expect(run_service).to be_falsey
      end

      it "does not reset the deregistration email communications history" do
        run_service

        expect(registration.communication_logs.find { |c| c.template_label = deregistration_comms_label }.created_at)
          .to be < 1.hour.ago
      end

      it "notifies errbit with the raised error" do
        run_service

        expect(Airbrake).to have_received(:notify).with(error, reference: registration.reference)
      end
    end
  end
end
