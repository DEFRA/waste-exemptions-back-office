# frozen_string_literal: true

FactoryBot.define do
  factory :registration_exemption, class: "WasteExemptionsEngine::RegistrationExemption" do
    exemption
    expires_on { Time.zone.today + 3.years }
    registered_on { Time.zone.today }

    trait :active do
      state { "active" }
    end

    trait :ceased do
      state { "ceased" }
      deregistration_message { "Ceased for reasons" }
      deregistered_at { Time.zone.today - 1.day }
    end

    trait :revoked do
      state { "revoked" }
      deregistration_message { "Revoked for reasons" }
      deregistered_at { Time.zone.today - 1.day }
    end

    trait :expired do
      state { "expired" }
    end

    trait :with_registration do
      registration
    end

    trait :expires_tomorrow do
      expires_on { Time.zone.today + 1.day }
      registered_on { (Time.zone.today + 1.day) - 3.years }
    end
  end
end
