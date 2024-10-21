# frozen_string_literal: true

FactoryBot.define do
  factory :company, class: "WasteExemptionsEngine::Company" do
    name { "ACME LTD" }
    company_no { "12345678" }
    active { true }
  end
end
