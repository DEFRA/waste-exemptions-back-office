# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: "WasteExemptionsEngine::Address" do
    sequence :postcode do |n|
      "BS#{n}#{n}AA"
    end

    sequence :uprn do |n|
      "uprn_#{n}"
    end

    sequence :premises do |n|
      "premises_#{n}"
    end

    sequence :street_address do |n|
      "street_address_#{n}"
    end

    sequence :locality do |n|
      "locality_#{n}"
    end

    sequence :city do |n|
      "city_#{n}"
    end

    address_type { 0 }

    trait :operator do
      address_type { :operator }
    end

    trait :contact do
      address_type { :contact }
    end

    trait :with_grid_reference do
      grid_reference { "ST 58337 72855" }
      x { 358_337.0 }
      y { 172_855.0 }
    end

    trait :site do
      address_type { :site }
      mode { :auto }
      description { "The waste is stored in an out-building next to the barn." }
      grid_reference { "ST 58337 72855" }

      sequence :x do |n|
        n
      end

      sequence :y do |n|
        n
      end

      uprn { nil }
      premises { nil }
      street_address { nil }
      locality { nil }
      city { nil }
      postcode { nil }
      country_iso { nil }
    end

    trait :site_uses_address do
      address_type { :site }
      mode { :lookup }
    end

    trait :operator_uses_address do
      address_type { :operator }
      mode { :lookup }
    end

    trait :contact_uses_address do
      address_type { :contact }
      mode { :lookup }
    end

    trait :short_description do
      description { Faker::Lorem.sentence(word_count: 3) }
    end

    trait :long_description do
      description { Faker::Lorem.sentence(word_count: 100) }
    end
  end
end
