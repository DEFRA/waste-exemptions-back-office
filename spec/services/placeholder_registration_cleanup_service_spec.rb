# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaceholderRegistrationCleanupService do
  describe ".run" do

    subject(:run_service) { described_class.run }

    let!(:placeholder_registration_5_days) { create(:registration, placeholder: true, created_at: 5.days.ago) }
    let!(:placeholder_registration_8_days) { create(:registration, placeholder: true, created_at: 8.days.ago) }
    let!(:completed_registration) { create(:registration, placeholder: true) }
    let!(:nil_status_registration) { create(:registration, placeholder: false) }

    before { allow(Rails.configuration).to receive(:max_transient_registration_age_days).and_return(7) }

    it { expect { run_service }.to change(WasteExemptionsEngine::Registration, :count).by(-1) }

    it { expect { run_service }.to change { WasteExemptionsEngine::Registration.find(placeholder_registration_5_days.id) }.to(nil) }

    it { expect { run_service }.not_to change { WasteExemptionsEngine::Registration.find(placeholder_registration_8_days.id) } }

    it { expect { run_service }.not_to change { WasteExemptionsEngine::Registration.find(completed_registration.id) } }

    it { expect { run_service }.not_to change { WasteExemptionsEngine::Registration.find(nil_status_registration.id) } }
  end
end
