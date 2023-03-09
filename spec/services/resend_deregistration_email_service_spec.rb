# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResendDeregistrationEmailService do
  around do |example|
    old_queue_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    example.run
  ensure
    ActiveJob::Base.queue_adapter = old_queue_adapter
  end

  describe "run" do
    subject(:run_service) do
      described_class.run(
        registration: registration
      )
    end

    let(:registration) do
      create(:registration, deregistration_email_sent_at: Time.zone.now.yesterday)
    end

    before do
      allow(Airbrake).to receive(:notify)
    end

    context "when successful" do
      it "resets the deregistration_email_sent_at timestamp" do
        run_service

        expect(registration.reload.deregistration_email_sent_at).to be_nil
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

      it "does not resets the deregistration_email_sent_at timestamp" do
        run_service

        expect(registration.reload.deregistration_email_sent_at).not_to be_nil
      end

      it "notifies errbit with the raised error" do
        run_service

        expect(Airbrake).to have_received(:notify).with(error, reference: registration.reference)
      end
    end
  end
end
