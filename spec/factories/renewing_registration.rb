# frozen_string_literal: true

FactoryBot.define do
  factory :renewing_registration, class: "WasteExemptionsEngine::RenewingRegistration" do
    # Create a new registration when initializing so we can copy its data
    registration { create(:registration) }

    initialize_with do
      new(reference: registration.reference, token: registration.renew_token)
    end

    trait :expires_tomorrow do
      registration { create(:registration, :expires_tomorrow) }
    end
  end
end
