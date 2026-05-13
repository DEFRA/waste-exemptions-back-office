# frozen_string_literal: true

FactoryBot.define do
  factory :edit_complete_form, class: "EditCompleteForm" do
    initialize_with do
      new(create(:edit_registration, :modified, workflow_state: "back_office_edit_complete_form"))
    end
  end
end
