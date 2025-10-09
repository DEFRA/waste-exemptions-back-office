# frozen_string_literal: true

require "rails_helper"

module Reports
  module FinanceDataReport
    RSpec.describe FarmComplianceChargeRowPresenter do
      let(:bucket) { build(:bucket, :farmer_exemptions) }
      let(:order) { build(:order, :with_exemptions, bucket: bucket) }
      let(:charge_detail) { build(:charge_detail, order: order, registration_charge_amount: 3150, bucket_charge_amount: 8850) }
      let(:registration) { build(:registration, reference: "REG123", submitted_at: Time.zone.now) }
      let(:presenter) { described_class.new(registration: registration, secondary_object: charge_detail, total: -1000) }

      before do
        bucket.exemptions << order.exemptions.last
      end

      describe "#charge_type" do
        it "returns 'registration'" do
          expect(presenter.charge_type).to eq("compliance_farm")
        end
      end

      describe "#charge_amount" do
        it "returns the formatted charge amount" do
          expect(presenter.charge_amount).to eq("88.50")
        end
      end

      describe "#exemption" do
        it "returns exemption code(s)" do
          expect(presenter.exemption).to be_present
        end

        # Work around a production data issue
        context "when no bucket is present" do
          before do
            order.update(bucket: nil)

            allow(Rails.logger).to receive(:warn)
            allow(Rails.logger).to receive(:error)
            allow(Airbrake).to receive(:notify)
          end

          it "does not raise an exception" do
            expect { presenter.exemption }.not_to raise_error
          end

          it "does not log an error" do
            presenter.exemption

            expect(Rails.logger).not_to have_received(:error)
          end

          it "logs registration details in the Rails log" do
            presenter.exemption

            expect(Rails.logger).to have_received(:warn).with(a_string_matching(registration.reference))
          end

          it "logs registration details to Errbit" do
            presenter.exemption

            expect(Airbrake).to have_received(:notify).with(a_string_matching(registration.reference))
          end
        end
      end

      describe "#balance" do
        it "returns the formatted balance amount" do
          expect(presenter.balance).to eq("-98.50")
        end
      end
    end
  end
end
