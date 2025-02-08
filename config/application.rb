# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/all"
require "active_record/connection_adapters/postgresql_adapter"
# require "rails/test_unit/railtie"
# See comment 'Add custom delivery method for emails' below
require_relative "../app/lib/notify_mail"

require "defra_ruby_features"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WasteExemptionsBackOffice
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoloader = :classic
    config.active_job.queue_adapter = :sucker_punch

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "London"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Rails.root.glob("config/locales/**/*.{rb,yml}")

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    # Don't add field_with_errors div wrapper around fields with errors. When
    # rails does this it messes with the GOV.UK styling and causes checkboxes
    # and radio buttons to become invisible
    config.action_view.field_error_proc = proc { |html_tag, _instance|
      html_tag.to_s
    }

    # https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#active-record-belongs-to-required-by-default-option
    config.active_record.belongs_to_required_by_default = false

    # https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#expiry-in-signed-or-encrypted-cookie-is-now-embedded-in-the-cookies-values
    # config.action_dispatch.use_authenticated_cookie_encryption = false

    # Paths
    config.front_office_url = ENV["FRONT_OFFICE_URL"] || "http://localhost:3000"
    config.back_office_url = ENV["BACK_OFFICE_URL"] || "http://localhost:8000"
    config.host = config.back_office_url

    config.private_beta_feedback_url = ENV.fetch("PRIVATE_BETA_FEEDBACK_URL", nil)

    # Companies House config
    config.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk"
    config.companies_house_api_key = ENV.fetch("COMPANIES_HOUSE_API_KEY", nil)

    # Data export config
    config.bulk_reports_bucket_name = ENV.fetch("AWS_BULK_EXPORT_BUCKET", nil)
    config.epr_reports_bucket_name = ENV.fetch("AWS_DAILY_EXPORT_BUCKET", nil)
    config.deregistration_email_bucket_name = ENV.fetch("AWS_DEREGISTRATION_EMAIL_EXPORT_BUCKET", nil)
    config.boxi_exports_bucket_name = ENV.fetch("AWS_BOXI_EXPORT_BUCKET", nil)
    config.epr_export_filename = ENV["EPR_DAILY_REPORT_FILE_NAME"] || "waste_exemptions_epr_daily_full"
    config.export_batch_size = ENV["EXPORT_SERVICE_BATCH_SIZE"] || 1000

    config.ad_letters_exports_expires_in = ENV["AD_LETTERS_EXPORT_EXPIRES_IN"] || 30
    config.ad_letters_delete_records_in = ENV["AD_LETTERS_DELETE_RECORDS_IN"] || 21

    # Minutes the EA area lookup job should run for
    config.area_lookup_run_for = ENV["AREA_LOOKUP_RUN_FOR"] || 60
    config.easting_and_northing_lookup_run_for = ENV["EASTING_AND_NORTHING_LOOKUP_RUN_FOR"] || 60

    # Emails
    config.email_test_address = ENV.fetch("EMAIL_TEST_ADDRESS", nil)
    config.second_renewal_email_reminder_days = ENV["SECOND_RENEWAL_EMAIL_BEFORE_DAYS"] || 14
    config.final_renewal_text_reminder_days = ENV["FINAL_RENEWAL_TEXT_BEFORE_DAYS"] || 7
    config.registration_email_batch_size = ENV.fetch("REGISTRATION_EMAIL_BATCH_SIZE", 1000)
    config.registration_email_batch_minimum_age_days = ENV.fetch("REGISTRATION_EMAIL_BATCH_MINIMUM_AGE",
                                                                 6.months.in_days).to_i

    # Govpay
    config.govpay_url = ENV["WEX_GOVPAY_URL"] || "https://publicapi.payments.service.gov.uk/v1"
    config.govpay_front_office_api_token = ENV.fetch("WEX_GOVPAY_FRONT_OFFICE_API_TOKEN", nil)
    config.govpay_back_office_api_token = ENV.fetch("WEX_GOVPAY_BACK_OFFICE_API_TOKEN", nil)

    # Database cleanup
    config.max_transient_registration_age_days = ENV["MAX_TRANSIENT_REGISTRATION_AGE_DAYS"] || 30

    # For analytics: The number of days after which we consider a user journey to be abandoned
    config.user_journey_abandoned_days = ENV.fetch("USER_JOURNEY_ABANDONED_DAYS", 2).to_i

    # Version info
    config.application_name = "waste-exemptions-back-office"
    config.git_repository_url = "https://github.com/DEFRA/#{config.application_name}"

    # Fix sass compilation error in govuk_frontend:
    # SassC::SyntaxError: Error: "calc(0px)" is not a number for `max'
    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil

    # Allow paper_trail to deserialise dates and times: https://stackoverflow.com/a/72970171
    config.active_record.yaml_column_permitted_classes = [
      ActiveSupport::TimeZone, ActiveSupport::TimeWithZone, Date, Time
    ]

    # Add custom delivery method for emails
    ActionMailer::Base.add_delivery_method(:notify_mail, NotifyMail)

    # Rails secrets is deprecated in favour of Rails credentials, but that
    # doesn't work for us so we want to mimic Rails secrets functionality:
    def self.secrets
      @secrets ||= begin
        secrets = ActiveSupport::OrderedOptions.new
        files = config.paths["config/secrets"].existent
        secrets.merge! parse_secrets(files)
      end
    end

    def parse_secrets(paths)
      paths.each_with_object({}) do |path, all_secrets|
        require "erb"

        secrets = YAML.load(ERB.new(File.read(path)).result, aliases: true) || {}
        all_secrets.merge!(secrets["shared"].deep_symbolize_keys) if secrets["shared"]
        all_secrets.merge!(secrets[Rails.env].deep_symbolize_keys) if secrets[Rails.env]
      end
    end
  end
end
