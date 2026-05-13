# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BackOfficeEditRegistration do
    describe "STI type" do
      it "keeps the legacy back-office edit registration type" do
        expect(create(:edit_registration).type).to eq("WasteExemptionsEngine::BackOfficeEditRegistration")
      end
    end
  end
end
