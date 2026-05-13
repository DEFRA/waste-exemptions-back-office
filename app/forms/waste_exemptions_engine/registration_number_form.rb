# frozen_string_literal: true

load WasteExemptionsEngine::Engine.root.join(
  "app",
  "forms",
  "waste_exemptions_engine",
  "registration_number_form.rb"
)

module WasteExemptionsEngine
  class RegistrationNumberForm < BaseForm
    def submit(params)
      params = params.to_h.symbolize_keys
      if transient_registration.is_a?(WasteExemptionsEngine::BackOfficeEditRegistration)
        update_edit_registration_details(params)
      end

      super
    end

    private

    def update_edit_registration_details(params)
      company_no = process_company_no(params[:temp_company_no])
      companies_house_details = DefraRuby::CompaniesHouse::API.run(company_number: company_no)

      params[:operator_name] = companies_house_details[:company_name]
      params[:company_no] = company_no
    end
  end
end
