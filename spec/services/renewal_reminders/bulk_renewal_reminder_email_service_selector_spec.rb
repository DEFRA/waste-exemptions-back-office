# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe BulkRenewalReminderEmailServiceSelector do
    describe ".first_reminder_service" do
      context "when enable_renewals feature is active" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true)
        end

        it "returns BulkFirstRenewalRemindersEmailService" do
          expect(described_class.first_reminder_service).to eq(BulkFirstRenewalRemindersEmailService)
        end
      end

      context "when enable_renewals feature is inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false)
        end

        it "returns BulkTemporaryFirstRenewalRemindersEmailService" do
          expect(described_class.first_reminder_service).to eq(BulkTemporaryFirstRenewalRemindersEmailService)
        end
      end
    end

    describe ".second_reminder_service" do
      context "when enable_renewals feature is active" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true)
        end

        it "returns BulkSecondRenewalRemindersEmailService" do
          expect(described_class.second_reminder_service).to eq(BulkSecondRenewalRemindersEmailService)
        end
      end

      context "when enable_renewals feature is inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false)
        end

        it "returns BulkTemporarySecondRenewalRemindersEmailService" do
          expect(described_class.second_reminder_service).to eq(BulkTemporarySecondRenewalRemindersEmailService)
        end
      end
    end

    describe ".first_reminder_email_service" do
      context "when enable_renewals feature is active" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true)
        end

        it "returns FirstRenewalReminderEmailService" do
          expect(described_class.first_reminder_email_service).to eq(FirstRenewalReminderEmailService)
        end
      end

      context "when enable_renewals feature is inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false)
        end

        it "returns TemporaryFirstRenewalReminderEmailService" do
          expect(described_class.first_reminder_email_service).to eq(TemporaryFirstRenewalReminderEmailService)
        end
      end
    end
  end
end
