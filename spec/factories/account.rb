# frozen_string_literal: true

FactoryBot.define do
  factory :account, class: "WasteExemptionsEngine::Account" do
    balance { 1_000 }

    trait :with_order do
      after(:build) do |acc|
        bands = WasteExemptionsEngine::Band.first(3).presence || build_list(:band, 3)
        exemptions = WasteExemptionsEngine::Exemption.first(3).presence || [
          build(:exemption, band: bands[0]),
          build(:exemption, band: bands[1]),
          build(:exemption, band: bands[2])
        ]

        site_count = [acc.registration&.site_addresses&.count.to_i, 1].max

        acc.orders << build(
          :order,
          :with_charge_detail,
          exemptions:,
          charge_detail: build(:charge_detail, site_count: site_count)
        )
        acc.payments << build(:payment, :with_order, account: acc)
      end
    end

    trait :with_payment do
      after(:build) do |acc|
        acc.payments << [build(:payment, :with_order, payment_status: "success")]
      end
    end
  end
end
