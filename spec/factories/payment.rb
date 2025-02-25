# frozen_string_literal: true

FactoryBot.define do
  factory :payment, class: "WasteExemptionsEngine::Payment" do
    payment_type { "govpay_payment" }
    payment_amount { 1000 }
    payment_status { "created" }
    payment_uuid { SecureRandom.uuid }
    reference { Faker::Lorem.word }
    date_time { Time.zone.now }
    account { association :account }

    trait :success do
      payment_status { "success" }
    end

    trait :bank_transfer do
      payment_type { WasteExemptionsEngine::Payment::PAYMENT_TYPE_BANK_TRANSFER }
      payment_status { WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS }
      payment_uuid { SecureRandom.uuid }
    end

    trait :with_order do
      order
    end

    trait :refund do
      payment_type { WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND }
      payment_status { WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS }
    end

    trait :reversal do
      payment_type { WasteExemptionsEngine::Payment::PAYMENT_TYPE_REVERSAL }
      payment_status { WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS }
    end
  end
end
