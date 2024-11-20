# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaceholderRegistrationCleanupService do
  describe ".run" do

    subject(:run_service) { described_class.run }

    let!(:placeholder_registration_5_days_id) { create(:registration, placeholder: true, created_at: 5.days.ago).id }
    let!(:placeholder_registration_8_days_id) { create(:registration, placeholder: true, created_at: 8.days.ago).id }
    let!(:non_placeholder_registration_id) { create(:registration, placeholder: false, created_at: 8.days.ago).id }
    let!(:nil_placeholder_registration_id) { create(:registration, placeholder: nil, created_at: 8.days.ago).id }

    before { allow(Rails.configuration).to receive(:max_transient_registration_age_days).and_return(7) }

    it { expect { run_service }.to change(WasteExemptionsEngine::Registration, :count).by(-1) }

    it { expect { run_service }.to change { WasteExemptionsEngine::Registration.find_by(id: placeholder_registration_8_days_id) }.to(nil) }

    it { expect { run_service }.not_to change { WasteExemptionsEngine::Registration.find_by(id: placeholder_registration_5_days_id) } }

    it { expect { run_service }.not_to change { WasteExemptionsEngine::Registration.find_by(id: non_placeholder_registration_id) } }

    it { expect { run_service }.not_to change { WasteExemptionsEngine::Registration.find_by(id: nil_placeholder_registration_id) } }
  end
end
