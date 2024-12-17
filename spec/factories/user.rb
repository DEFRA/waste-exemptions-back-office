# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end

    role { "admin_team_user" }
    password { "Secret123" }

    trait :admin_team_user do
      role { "admin_team_user" }
    end

    trait :customer_service_adviser do
      role { "customer_service_adviser" }
    end

    trait :data_viewer do
      role { "data_viewer" }
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

    trait :policy_adviser do
      role { "policy_adviser" }
    end

    trait :finance_user do
      role { "finance_user" }
    end

    trait :inactive do
      active { false }
    end
  end
end
