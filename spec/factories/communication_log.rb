# frozen_string_literal: true

FactoryBot.define do
  factory :communication_log, class: "WasteExemptionsEngine::CommunicationLog" do
    message_type { %w[letter email text].sample }
    template_id { SecureRandom.hex(12) }
    template_label { Faker::Lorem.word }

    trait :email do
      message_type { "email" }
      sent_to { Faker::Internet.email }
    end

    trait :letter do
      message_type { "letter" }
      sent_to { "17 The Street, the town, the city, DLX4XX" }
    end

    trait :text do
      message_type { "letter" }
      sent_to { Faker::PhoneNumber.cell_phone }
    end
  end
end
