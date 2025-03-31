# frozen_string_literal: true

require "defra_ruby/companies_house"

class RefreshCompaniesHouseNameService < WasteExemptionsEngine::BaseService
  def run(company_reference)
    registration = WasteExemptionsEngine::Registration.find_by(reference: company_reference)

    companies_house_details = DefraRuby::CompaniesHouse::API.run(company_number: registration.company_no)
    company_name = companies_house_details[:company_name]

    registration.operator_name = company_name
    registration.companies_house_updated_at = Time.current
    registration.reason_for_change = I18n.t("refresh_companies_house_name.messages.reason_for_change")
    registration.save!

    true
  end
end
