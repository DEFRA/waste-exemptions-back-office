# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalServiceSwitcher do
  describe ".first_reminder_service" do
    context "when enable_renewals feature is active" do
      before do
        allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true)
      end

      it "returns FirstRenewalReminderService" do
        expect(described_class.first_reminder_service).to eq(FirstRenewalReminderService)
      end
    end

    context "when enable_renewals feature is inactive" do
      before do
        allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false)
      end

      it "returns TemporaryFirstRenewalReminderService" do
        expect(described_class.first_reminder_service).to eq(TemporaryFirstRenewalReminderService)
      end
    end
  end

  describe ".second_reminder_service" do
    context "when enable_renewals feature is active" do
      before do
        allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true)
      end

      it "returns SecondRenewalReminderService" do
        expect(described_class.second_reminder_service).to eq(SecondRenewalReminderService)
      end
    end

    context "when enable_renewals feature is inactive" do
      before do
        allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false)
      end

      it "returns TemporarySecondRenewalReminderService" do
        expect(described_class.second_reminder_service).to eq(TemporarySecondRenewalReminderService)
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
