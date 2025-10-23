# frozen_string_literal: true

FactoryBot.define do
  address_types = WasteExemptionsEngine::Address.address_types
  modes = WasteExemptionsEngine::Address.modes

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

    mode { :lookup }

    trait :with_grid_reference do
      grid_reference { "ST 58337 72855" }
      x { 358_337.0 }
      y { 172_855.0 }
    end

    trait :operator_address do
      address_type { address_types[:operator] }
    end

    trait :contact_address do
      address_type { address_types[:contact] }
    end

    trait :postal do
      manual

      sequence :postcode do |n|
        "BS#{n}AA"
      end

      uprn { Faker::Alphanumeric.unique.alphanumeric(number: 8) }
      premises { Faker::Address.community }
      street_address { Faker::Address.street_address }
      locality { Faker::Address.country }
      city { Faker::Address.city }
    end

    trait :manual do
      mode { modes[:manual] }
    end

    trait :site_address do
      address_type { address_types[:site] }
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

    trait :short_description do
      description { Faker::Lorem.sentence(word_count: 3) }
    end

    trait :long_description do
      description { Faker::Lorem.sentence(word_count: 100) }
    end
  end
end
