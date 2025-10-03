# frozen_string_literal: true

FactoryBot.define do
  factory :registration, class: "WasteExemptionsEngine::Registration" do
    location { "england" }
    business_type { "limitedCompany" }
    company_no { "10336040" }
    on_a_farm { true }
    is_a_farmer { true }
    account { build(:account) }

    submitted_at { DateTime.now }

    registration_exemptions { build_list(:registration_exemption, 3) }

    sequence :applicant_email do |n|
      "applicant#{n}@example.com"
    end

    sequence :applicant_first_name do |n|
      "Firstapp#{n}"
    end

    sequence :applicant_last_name do |n|
      "Lastapp#{n}"
    end

    sequence :contact_email do |n|
      "contact#{n}@example.com"
    end

    sequence :contact_first_name do |n|
      "Firstcontact#{n}"
    end

    sequence :contact_last_name do |n|
      "Lastcontact#{n}"
    end

    sequence :contact_phone do |n|
      "0123456789#{n}"
    end

    sequence :applicant_phone do |n|
      "0987654321#{n}"
    end

    sequence :operator_name do |n|
      "Operator #{n}"
    end

    sequence :reference do |n|
      "WEX#{n}"
    end

    addresses do
      [build(:address, :operator),
       build(:address, :contact),
       build(:address, :site)]
    end

    trait :limited_company do
      business_type { "limitedCompany" }
    end

    trait :limited_liability_partnership do
      business_type { "limitedLiabilityPartnership" }
    end

    trait :local_authority do
      business_type { "localAuthority" }
      company_no { nil }
    end

    trait :charity do
      business_type { "charity" }
      company_no { nil }
    end

    trait :partnership do
      business_type { "partnership" }
      people { build_list(:person, 2) }
      company_no { nil }
    end

    trait :sole_trader do
      business_type { "soleTrader" }
      company_no { nil }
    end

    trait :site_uses_address do
      addresses do
        [build(:address, :operator),
         build(:address, :contact),
         build(:address, :site_uses_address)]
      end
    end

    trait :with_active_exemptions do
      after(:build) do |reg|
        reg.registration_exemptions.each do |re|
          re.state = :active
          re.expires_on = Time.zone.today + 3.years
          re.registered_on = Time.zone.today
        end
      end
    end

    trait :with_ceased_exemptions do
      registration_exemptions { build_list(:registration_exemption, 3, :ceased) }
    end

    trait :eligible_for_deregistration do
      submitted_at do
        7.months.ago.to_date
      end

      registration_exemptions do
        build_list(:registration_exemption, 1, :active)
      end
    end

    trait :expires_tomorrow do
      registration_exemptions { build_list(:registration_exemption, 3, :expires_tomorrow) }
    end

    trait :with_short_site_description do
      addresses do
        [build(:address, :operator),
         build(:address, :contact),
         build(:address, :site, :short_description)]
      end
    end

    trait :has_no_email do
      contact_email { nil }
    end

    trait :with_long_site_description do
      addresses do
        [build(:address, :operator),
         build(:address, :contact),
         build(:address, :site, :long_description)]
      end
    end

    trait :with_people do
      people { build_list(:person, 2) }
    end

    trait :with_valid_mobile_phone_number do
      contact_phone { "07851456789" }
    end

    trait :with_manual_site_address do
      addresses do
        [build(:address, :operator_address, :postal),
         build(:address, :contact_address, :postal),
         build(:address, :site_address, :manual, :postal)]
      end
    end

    trait :multi_site do
      is_multisite_registration { true }
    end
  end
end
