# frozen_string_literal: true

FactoryBot.define do
  factory :charge_adjustment, class: "WasteExemptionsEngine::ChargeAdjustment" do
    amount { Faker::Number.between(from: 10_000, to: 99_900) }
    adjustment_type { %w[increase decrease].sample }
    reason { Faker::Lorem.sentence }
  end
end

