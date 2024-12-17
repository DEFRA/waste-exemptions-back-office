# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe AdjustChargeService do
    subject(:service) { described_class.new }

    let(:registration) { create(:registration) }
    let(:account) { create(:account, registration: registration) }
    let(:amount) { 10_000 }
    let(:reason) { "Charge adjustment due to processing error" }
    let(:adjustment_type) { "decrease" }

    describe "#run" do
      context "when the charge adjustment is processed successfully" do
        it "creates a new charge adjustment record" do
          expect do
            service.run(
              account: account,
              adjustment_type: adjustment_type,
              amount: amount,
              reason: reason
            )
          end.to change(ChargeAdjustment, :count).by(1)
        end

        it "creates the charge adjustment with correct attributes" do
          service.run(
            account: account,
            adjustment_type: adjustment_type,
            amount: amount,
            reason: reason
          )

          adjustment = ChargeAdjustment.last
          expect(adjustment).to have_attributes(
            account: account,
            amount: amount,
            adjustment_type: adjustment_type,
            reason: reason
          )
        end

        it "returns true" do
          result = service.run(
            account: account,
            adjustment_type: adjustment_type,
            amount: amount,
            reason: reason
          )
          expect(result).to be true
        end
      end

      context "when an error occurs" do
        before do
          allow(ChargeAdjustment).to receive(:create!).and_raise(StandardError)
        end

        it "logs the error" do
          logger = instance_double(Logger)
          allow(logger).to receive(:error)
          allow(Rails).to receive(:logger).and_return(logger)

          service.run(
            account: account,
            adjustment_type: adjustment_type,
            amount: amount,
            reason: reason
          )

          expect(logger).to have_received(:error).with("StandardError error processing charge decrease")
        end

        it "notifies Airbrake" do
          allow(Airbrake).to receive(:notify)

          service.run(
            account: account,
            adjustment_type: adjustment_type,
            amount: amount,
            reason: reason
          )

          expect(Airbrake).to have_received(:notify).with(
            instance_of(StandardError),
            message: "Error processing charge decrease"
          )
        end

        it "returns false" do
          result = service.run(
            account: account,
            adjustment_type: adjustment_type,
            amount: amount,
            reason: reason
          )
          expect(result).to be false
        end

        it "does not create a new charge adjustment record" do
          expect do
            service.run(
              account: account,
              adjustment_type: adjustment_type,
              amount: amount,
              reason: reason
            )
          end.not_to change(ChargeAdjustment, :count)
        end
      end
    end
  end
end
