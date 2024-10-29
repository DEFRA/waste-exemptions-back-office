# frozen_string_literal: true

FactoryBot.define do
  factory :account, class: "WasteExemptionsEngine::Account" do
    balance { Faker::Number.between(from: 50, to: 10_000) }
  end
end
