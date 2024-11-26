# frozen_string_literal: true

FactoryBot.define do
  factory :account, class: "WasteExemptionsEngine::Account" do
    balance { 1_000 }

    trait :with_order do
      after(:build) do |acc|
        bands = WasteExemptionsEngine::Band.first(3) || build_list(:band, 3)
        exemptions = WasteExemptionsEngine::Exemption.first(3) || [
          build(:exemption, band: bands[0]),
          build(:exemption, band: bands[1]),
          build(:exemption, band: bands[2])
        ]
        acc.orders << build(:order,
                            :with_charge_detail,
                            exemptions:)
      end
    end

    trait :with_payment do
      after(:build) do |acc|
        acc.payments << [build(:payment, :with_order, payment_status: "success")]
      end
    end
  end
end
