# frozen_string_literal: true

FactoryBot.define do
  factory :edit_form, class: "EditForm" do
    initialize_with do
      new(create(:edit_registration, workflow_state: "back_office_edit_form"))
    end
  end
end
