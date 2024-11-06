# frozen_string_literal: true

FactoryBot.define do
  factory :account, class: "WasteExemptionsEngine::Account" do
    balance { Faker::Number.between(from: 50, to: 10_000) }

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
                            payments: [build(:payment)],
                            exemptions:)
      end
    end
  end
end
