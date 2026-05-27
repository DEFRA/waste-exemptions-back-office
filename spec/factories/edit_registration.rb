# frozen_string_literal: true

FactoryBot.define do
  factory :edit_registration, class: "WasteExemptionsEngine::BackOfficeEditRegistration" do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      new(reference: create(:registration).reference)
    end

    trait :with_people do
      initialize_with do
        new(reference: create(:registration, :with_people).reference)
      end
    end

    trait :with_manual_site_address do
      initialize_with do
        new(reference: create(:registration, :with_manual_site_address).reference)
      end
    end

    trait :modified do
      after(:build) do |edit_registration|
        registration = edit_registration.registration

        %w[
          applicant_email
          applicant_first_name
          applicant_last_name
          contact_email
          contact_first_name
          contact_last_name
          contact_phone
          contact_position
          operator_name
        ].each do |attribute|
          edit_registration[attribute] = "#{registration[attribute]}foo"
        end

        %i[is_a_farmer on_a_farm].each do |attribute|
          edit_registration[attribute] = !registration[attribute]
        end
      end

      modified_addresses
    end

    trait :modified_addresses do
      after(:build) do |edit_registration|
        edit_registration.addresses.each do |address|
          %w[postcode premises street_address locality city description].each do |attribute|
            address[attribute] = "#{address[attribute]}foo" if address[attribute].is_a?(String)
          end

          address.save if address.persisted?
        end
      end
    end

    trait :modified_people do
      with_people

      after(:build) do |edit_registration|
        edit_registration.people.each do |person|
          person.attributes.each do |key, value|
            person[key] = "#{value}foo" if value.is_a?(String)
          end
        end
      end
    end

    trait :multisite do
      initialize_with do
        new(reference: create(:registration, :multisite_complete).reference)
      end
    end
  end
end
