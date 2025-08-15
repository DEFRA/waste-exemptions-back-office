# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe BulkRenewalReminderEmailServiceSelector do
    describe ".first_reminder_service" do
      context "when enable_renewals feature is active" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true)
        end

        it "returns BulkFirstRenewalRemindersService" do
          expect(described_class.first_reminder_service).to eq(BulkFirstRenewalRemindersService)
        end
      end

      context "when enable_renewals feature is inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false)
        end

        it "returns BulkTemporaryFirstRenewalRemindersService" do
          expect(described_class.first_reminder_service).to eq(BulkTemporaryFirstRenewalRemindersService)
        end
      end
    end

    describe ".second_reminder_service" do
      context "when enable_renewals feature is active" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true)
        end

        it "returns BulkSecondRenewalRemindersService" do
          expect(described_class.second_reminder_service).to eq(BulkSecondRenewalRemindersService)
        end
      end

      context "when enable_renewals feature is inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false)
        end

        it "returns BulkTemporarySecondRenewalRemindersService" do
          expect(described_class.second_reminder_service).to eq(BulkTemporarySecondRenewalRemindersService)
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

    describe ".second_reminder_email_service" do
      context "when enable_renewals feature is active" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true)
        end

        it "returns SecondRenewalReminderEmailService" do
          expect(described_class.second_reminder_email_service).to eq(SecondRenewalReminderEmailService)
        end
      end

      context "when enable_renewals feature is inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false)
        end

        it "returns TemporarySecondRenewalReminderEmailService" do
          expect(described_class.second_reminder_email_service).to eq(TemporarySecondRenewalReminderEmailService)
        end
      end
    end
  end
end
