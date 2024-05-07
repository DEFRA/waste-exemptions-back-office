# frozen_string_literal: true

FactoryBot.define do
  factory :band, class: "WasteExemptionsEngine::Band" do
    sequence(:name) { |n| "Band #{n}" }
    sequence(:sequence) { |n| n }
    registration_charge { 100 }
    initial_compliance_charge { 50 }
    additional_compliance_charge { 25 }
  end
end
