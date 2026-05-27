# frozen_string_literal: true

FactoryBot.define do
  factory :reason_for_change_form, class: "ReasonForChangeForm" do
    initialize_with do
      new(create(:edit_registration, workflow_state: "reason_for_change_form"))
    end
  end
end
