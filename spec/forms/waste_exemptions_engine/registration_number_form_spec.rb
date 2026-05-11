# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationNumberForm, type: :model do
    subject(:form) { described_class.new(edit_registration) }

    let(:edit_registration) do
      create(:back_office_edit_registration, workflow_state: "registration_number_form", temp_company_no: "09360070")
    end
    let(:company_name) { "Acme Waste Ltd" }

    before do
      allow(DefraRuby::CompaniesHouse::API)
        .to receive(:run)
        .and_return(company_name: company_name, registered_office_address: [], company_status: :active)
    end

    it "stores company details as copyable attributes for back-office edits" do
      expect do
        form.submit(temp_company_no: "12345678")
      end.to change { edit_registration.reload.company_no }.to("12345678")
                                                           .and change { edit_registration.reload.operator_name }.to(company_name)
    end

    it "inherits from the engine base form" do
      expect(form).to be_a(WasteExemptionsEngine::BaseForm)
    end
  end
end
