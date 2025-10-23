# frozen_string_literal: true

FactoryBot.define do
  address_types = WasteExemptionsEngine::Address.address_types

  factory :transient_address, class: "WasteExemptionsEngine::TransientAddress" do
    sequence :postcode do |n|
      "BS#{n}AA"
    end

    address_type { 0 }

    trait :operator_address do
      address_type { address_types[:operator] }
    end

    trait :contact_address do
      address_type { address_types[:contact] }
    end

    trait :site_address do
      address_type { address_types[:site] }
    end
  end
end
