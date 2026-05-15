# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BackOfficeEditRegistration do
    describe "STI type" do
      it "keeps the legacy back-office edit registration type" do
        expect(create(:edit_registration).type).to eq("WasteExemptionsEngine::BackOfficeEditRegistration")
      end
    end

    describe "workflow state" do
      it "keeps the legacy initial workflow state" do
        expect(create(:edit_registration).workflow_state).to eq("back_office_edit_form")
      end
    end
  end
end
