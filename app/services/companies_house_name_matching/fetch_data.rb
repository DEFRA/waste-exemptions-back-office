# frozen_string_literal: true

require "defra_ruby/companies_house"

module CompaniesHouseNameMatching
  class FetchData
    def self.fetch_active_registrations
      recently_updated_companies = WasteExemptionsEngine::Company.recently_updated.select(:company_no)

      WasteExemptionsEngine::Registration
        .joins(:registration_exemptions)
        .where(registration_exemptions: { state: :active })
        .where.not(operator_name: nil)
        .where("company_no IS NOT NULL AND company_no != ''")
        .where.not(company_no: recently_updated_companies)
        .distinct
    end

    def self.fetch_companies_house_name(company_no)
      companies_house_details = DefraRuby::CompaniesHouse::API.new.run(company_number: company_no)
      companies_house_details[:company_name]
    rescue StandardError => e
      Rails.logger.error("Failed to fetch company name for #{company_no}: #{e.message}")
      nil
    end
  end
end
