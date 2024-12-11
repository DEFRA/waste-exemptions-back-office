# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end

    role { "system" }
    password { "Secret123" }

    trait :system do
      role { "system" }
    end

    trait :admin_agent do
      role { "admin_agent" }
    end

    trait :data_agent do
      role { "data_agent" }
    end

    trait :developer do
      role { "developer" }
    end

    trait :service_manager do
      role { "service_manager" }
    end

    trait :admin_team_lead do
      role { "admin_team_lead" }
    end

    trait :inactive do
      active { false }
    end
  end
end
