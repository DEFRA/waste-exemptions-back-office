# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "excludes free renewals" do |bulk_service, registration_service, expires_on|
  subject(:run_service) { bulk_service.run }

  let!(:t28_exemption) { create(:exemption, code: "T28") }

  let!(:active_expiring_not_free_registration) do
    create(
      :registration,
      :with_valid_mobile_phone_number,
      registration_exemptions: [
        build(:registration_exemption, :active, expires_on:),
        build(:registration_exemption, :revoked, expires_on:)
      ]
    )
  end

  let!(:active_expiring_charity_registration) do
    create(
      :registration,
      :with_valid_mobile_phone_number,
      business_type: "charity",
      registration_exemptions: [
        build(:registration_exemption, :active, expires_on:),
        build(:registration_exemption, :revoked, expires_on:)
      ]
    )
  end

  let!(:active_expiring_t28_registration) do
    create(
      :registration,
      :with_valid_mobile_phone_number,
      registration_exemptions: [
        build(:registration_exemption, :active, exemption: t28_exemption, expires_on:),
        build(:registration_exemption, :revoked, expires_on:)
      ]
    )
  end

  let!(:active_expiring_charity_t28_registration) do
    create(
      :registration,
      :with_valid_mobile_phone_number,
      business_type: "charity",
      registration_exemptions: [
        build(:registration_exemption, :active, exemption: t28_exemption, expires_on:),
        build(:registration_exemption, :revoked, expires_on:)
      ]
    )
  end

  before do
    allow(registration_service).to receive(:run)

    run_service
  end

  it { expect(registration_service).to have_received(:run).with(registration: active_expiring_not_free_registration).at_least(:once) }
  it { expect(registration_service).not_to have_received(:run).with(registration: active_expiring_charity_registration) }
  it { expect(registration_service).not_to have_received(:run).with(registration: active_expiring_t28_registration) }
  it { expect(registration_service).not_to have_received(:run).with(registration: active_expiring_charity_t28_registration) }
end
