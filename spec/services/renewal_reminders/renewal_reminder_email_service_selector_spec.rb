# frozen_string_literal: true

require "rails_helper"

module RenewalReminders

  RSpec.describe RenewalReminderEmailServiceSelector do
    let(:t28_exemption) { WasteExemptionsEngine::Exemption.find_by(code: "T28") || create(:exemption, code: "T28") }

    let(:chargeable_registration) do
      create(:registration, business_type: "soleTrader",
                            registration_exemptions: [build(:registration_exemption, expires_on:)])
    end
    let(:charity_registration) do
      create(:registration, business_type: "charity",
                            registration_exemptions: [build(:registration_exemption, expires_on:)])
    end
    let(:legacy_bulk_registration) do
      create(:registration, is_legacy_bulk: true,
                            registration_exemptions: [build(:registration_exemption, expires_on:)])
    end
    let(:t28_registration) do
      create(:registration,
             registration_exemptions: [build(:registration_exemption, exemption: t28_exemption, expires_on:)])
    end

    describe ".first_reminder_email_service" do
      let(:expires_on) { 4.weeks.from_now.to_date }

      context "when enable_renewals feature is active" do
        before { allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true) }

        it { expect(described_class.first_reminder_email_service(chargeable_registration)).to eq(FirstRenewalReminderEmailService) }
        it { expect(described_class.first_reminder_email_service(charity_registration)).to eq(FreeFirstRenewalReminderEmailService) }
        it { expect(described_class.first_reminder_email_service(t28_registration)).to eq(FirstRenewalReminderEmailService) }

        it { expect(described_class.first_reminder_email_service(legacy_bulk_registration)).to eq(FirstRenewalReminderEmailService) }
      end

      context "when enable_renewals feature is inactive" do
        before { allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false) }

        it { expect(described_class.first_reminder_email_service(chargeable_registration)).to eq(TemporaryFirstRenewalReminderEmailService) }
        it { expect(described_class.first_reminder_email_service(charity_registration)).to eq(FreeFirstRenewalReminderEmailService) }
        it { expect(described_class.first_reminder_email_service(t28_registration)).to eq(TemporaryFirstRenewalReminderEmailService) }

        it { expect(described_class.first_reminder_email_service(legacy_bulk_registration)).to eq(FirstRenewalReminderEmailService) }
      end
    end

    describe ".second_reminder_service" do
      let(:expires_on) { 2.weeks.from_now.to_date }

      context "when enable_renewals feature is active" do
        before { allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(true) }

        it { expect(described_class.second_reminder_email_service(chargeable_registration)).to eq(SecondRenewalReminderEmailService) }
        it { expect(described_class.second_reminder_email_service(charity_registration)).to eq(FreeSecondRenewalReminderEmailService) }
        it { expect(described_class.second_reminder_email_service(t28_registration)).to eq(SecondRenewalReminderEmailService) }

        it { expect(described_class.second_reminder_email_service(legacy_bulk_registration)).to eq(SecondRenewalReminderEmailService) }
      end

      context "when enable_renewals feature is inactive" do
        before { allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_renewals).and_return(false) }

        it { expect(described_class.second_reminder_email_service(chargeable_registration)).to eq(TemporarySecondRenewalReminderEmailService) }
        it { expect(described_class.second_reminder_email_service(charity_registration)).to eq(FreeSecondRenewalReminderEmailService) }
        it { expect(described_class.second_reminder_email_service(t28_registration)).to eq(TemporarySecondRenewalReminderEmailService) }

        it { expect(described_class.second_reminder_email_service(legacy_bulk_registration)).to eq(SecondRenewalReminderEmailService) }
      end
    end
  end
end
