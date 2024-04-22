# frozen_string_literal: true

WasteExemptionsEngine.configure do |configuration|
  # Assisted digital config
  configuration.assisted_digital_email = ENV["WEX_ASSISTED_DIGITAL_EMAIL"] ||
                                         "waste-exemptions@environment-agency.gov.uk"

  # General config
  configuration.application_name = "waste-exemptions-back-office"
  configuration.git_repository_url = "https://github.com/DEFRA/waste-exemptions-back-office"
  configuration.host_is_back_office = true

  # Companies house API config
  configuration.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
  configuration.companies_house_api_key = ENV.fetch("COMPANIES_HOUSE_API_KEY", nil)

  # Address lookup config
  configuration.address_host = ENV["ADDRESSBASE_URL"] || "http://localhost:3002"

  # Email config
  configuration.service_name = ENV["EMAIL_SERVICE_NAME"] || "Waste Exemptions Service"
  configuration.email_service_email = ENV["EMAIL_SERVICE_EMAIL"] || "wex-local@example.com"

  # Assisted digital config
  configuration.default_assistance_mode = "full"

  # Edit config
  configuration.edit_enabled = "true"

  # Last email cache config
  configuration.use_last_email_cache = ENV["USE_LAST_EMAIL_CACHE"] || "false"

  # Renewing config
  configuration.renewal_window_before_expiry_in_days = ENV["RENEWAL_WINDOW_BEFORE_EXPIRY_IN_DAYS"] || 28
  configuration.renewal_window_after_expiry_in_days = ENV["RENEWAL_WINDOW_AFTER_EXPIRY_IN_DAYS"] || 30

  # Configure airbrake, which is done via the engine using defra_ruby_alert
  configuration.airbrake_enabled = ENV.fetch("USE_AIRBRAKE", nil)
  configuration.airbrake_host = ENV.fetch("AIRBRAKE_HOST", nil)
  configuration.airbrake_project_key = ENV.fetch("AIRBRAKE_BO_PROJECT_KEY", nil)
  configuration.airbrake_blocklist = [/password/i, /authorization/i]

  # Notify config
  configuration.notify_api_key = ENV.fetch("NOTIFY_API_KEY", nil)

  # Enable user tracking in PaperTrail
  configuration.use_current_user_for_whodunnit = "true"
end
WasteExemptionsEngine.start_airbrake
