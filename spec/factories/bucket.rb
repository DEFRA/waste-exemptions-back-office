# frozen_string_literal: true

FactoryBot.define do
  factory :bucket, class: 'WasteExemptionsEngine::Bucket' do
    sequence(:name) { |n| "Bucket #{n}" }
    charge_amount { 75 }
  end
end
