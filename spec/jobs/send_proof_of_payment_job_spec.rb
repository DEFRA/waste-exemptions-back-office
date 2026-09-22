# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendProofOfPaymentJob do
  subject(:run_job) { described_class.new.perform(reference:) }

  let(:registration) { create(:registration) }
  let(:reference) { registration.reference }

  before do
    allow(WasteExemptionsEngine::ProofOfPaymentService).to receive(:run)
  end

  it "checks and sends proof of payment for the registration" do
    run_job

    expect(WasteExemptionsEngine::ProofOfPaymentService).to have_received(:run).with(registration:)
  end

  context "when the registration does not exist" do
    let(:reference) { "unknown" }

    it "does nothing" do
      run_job

      expect(WasteExemptionsEngine::ProofOfPaymentService).not_to have_received(:run)
    end
  end

  context "when sending fails" do
    let(:error) { StandardError.new("Test error") }

    before do
      allow(Airbrake).to receive(:notify)
      allow(Rails.logger).to receive(:error)
      allow(WasteExemptionsEngine::ProofOfPaymentService).to receive(:run).and_raise(error)
    end

    it "logs the error" do
      run_job

      expect(Rails.logger).to have_received(:error).with("Proof of payment error: Test error")
    end

    it "notifies Airbrake" do
      run_job

      expect(Airbrake).to have_received(:notify).with(error, reference:)
    end
  end
end
