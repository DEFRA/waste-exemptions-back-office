# frozen_string_literal: true

FactoryBot.define do
  factory :modify_expiry_date_form, class: "ModifyExpiryDateForm" do
    initialize_with do
      new(create(:registration, :with_active_exemptions))
    end
  end
end
