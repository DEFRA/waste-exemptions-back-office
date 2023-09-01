# frozen_string_literal: true

FactoryBot.define do
  factory :registration_communication_log, class: "WasteExemptionsEngine::RegistrationCommunicationLog" do
    registration { association :registration }
    communication_log { association :communication_log }

    trait :email do
      communication_log { association :communication_log, :email }
    end

    trait :letter do
      communication_log { association :communication_log, :letter }
    end

    trait :text do
      communication_log { association :communication_log, :text }
    end
  end
end
