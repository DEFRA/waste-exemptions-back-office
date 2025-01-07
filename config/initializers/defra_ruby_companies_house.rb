# frozen_string_literal: true

require "defra_ruby/companies_house"

DefraRuby::CompaniesHouse.configure do |config|
  config.companies_house_host = "https://api.companieshouse.gov.uk"
  config.companies_house_api_key = "2vhuj0oWabMw7hzNzAUiSOg-6KiUTBpXBD_7fKbo"
end
