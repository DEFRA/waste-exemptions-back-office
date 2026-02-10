# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!

# Use Selenium Chrome driver in headless mode. Poltergeist has issues loading JS.
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome,
                                      options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu]))
end
Capybara.javascript_driver = :chrome
Capybara.server = :webrick

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
# rubocop:disable RSpec/Output
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
# rubocop:enable RSpec/Output

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# We make an exception for simplecov because that will already have been
# required and run at the very top of spec_helper.rb
support_files = Dir["./spec/support/**/*.rb"].reject { |file| file == "./spec/support/simplecov.rb" }
support_files.each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers, type: :feature
  config.include ActiveSupport::Testing::TimeHelpers
  config.include AbstractController::Translation # enables t()

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before do
    # Don't make external API calls during specs
    stub_request(:get, %r{/address-service/v1/addresses/})
    stub_request(:get, %r{environment.data.gov.uk/spatialdata/})
    stub_request(:post, %r{/errbit-prd.aws-int.defra.cloud/})
    stub_request(:put, %r{/devwex.*s3.eu-west-1.amazonaws.com/})

    Bullet.start_request
  end
  config.after do
    # Avoid Faker::UniqueGenerator::RetryLimitExceeded errors
    Faker::UniqueGenerator.clear

    Bullet.end_request
  end
end
