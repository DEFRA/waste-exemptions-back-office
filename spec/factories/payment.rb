# frozen_string_literal: true

FactoryBot.define do
  factory :payment, class: "WasteExemptionsEngine::Payment" do
    payment_type { "govpay_payment" }
    payment_amount { 1000 }
    payment_status { "created" }
    payment_uuid { SecureRandom.uuid }

    trait :bank_transfer do
      payment_type { WasteExemptionsEngine::Payment::PAYMENT_TYPE_BANK_TRANSFER }
      payment_status { WasteExemptionsEngine::Payment::PAYMENT_STATUS_SUCCESS }
      payment_uuid { SecureRandom.uuid }
    end
  end
end

