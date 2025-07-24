# frozen_string_literal: true

source "https://rubygems.org"
ruby "3.2.2"

# Allows us to automatically generate the change log from the tags, issues,
# labels and pull requests on GitHub. Added as a dependency so all dev's have
# access to it to generate a log, and so they are using the same version.
# New dev's should first create GitHub personal app token and add it to their
# ~/.bash_profile (or equivalent)
# https://github.com/skywinder/github-changelog-generator#github-token
# Then simply run `bundle exec rake changelog` to update CHANGELOG.md
# Should be in the :development group however when it is it breaks deployment
# to Heroku. Hence moved outside group till we can understand why.
gem "github_changelog_generator", require: false

# GOV.UK design system styling
gem "defra_ruby_template", "~> 5.11"
# GOV.UK design system forms
gem "govuk_design_system_formbuilder"
# GOV.UK Notify gem. Allows us to send email via the Notify web API
gem "notifications-ruby-client"
# Use jquery as the JavaScript library
gem "jquery-rails"
# Use postgresql as the database for Active Record

gem "matrix"

gem "net-imap"
gem "net-pop"
gem "net-smtp"

gem "pg"
# Automatically kills connections to Postgres when running rake tasks that
# involve a database drop. Stops the error
# PG::ObjectInUse: ERROR:  database "wex_db" is being accessed by other users
gem "pgreset"
# See: https://github.com/sass/sassc-rails/issues/114
gem "sassc-rails"

# Pin rack version to avoid this issue: https://github.com/phusion/passenger/issues/2508
gem "rack", "~> 2"

# Automatically apply http headers that are related to security
gem "secure_headers", "~> 6.5"
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"

# Use CanCanCan for user roles and permissions
gem "cancancan", "~> 3.5"

# Use Devise for user authentication
gem "devise"
gem "devise_invitable"

# Use Kaminari for pagination
gem "kaminari", "~> 1.2"

# Use Whenever to manage cron tasks
gem "whenever", "~> 1.0"

# Used for auditing and version control
gem "paper_trail"

# Used for handling background processes
gem "sucker_punch", "~> 3.2"

# Use the waste exemptions engine for the user journey from the local repo
gem "waste_exemptions_engine",
    git: "https://github.com/DEFRA/waste-exemptions-engine",
    # This is to pick up engine hotfix changes. TBD: Revert to main when postGIS changes are ready.
    branch: "chore/changelog_20250702"

# Use the mocks for testing govpay  functionality
gem "defra_ruby_mocks"

# Use the Defra Ruby Features gem to allow users with the correct permissions to
# manage feature toggle (create / update / delete) from the back-office.
gem "defra_ruby_features", "~> 0.2"

# Use the Defra Ruby Aws gem for loading files to AWS buckets
gem "defra_ruby_aws", "~> 0.5"

# Manage, create and open zip files https://github.com/rubyzip/rubyzip
gem "rubyzip"

# Load this in all environments, not just test, to support the /testing helper:
gem "factory_bot_rails"

# The Retry middleware automatically retries requests that fail
gem "faraday-retry"

# Compare two hashes and return diff
gem "hashdiff"

# Generate test data. Also used by the create_registration test helper,
# so it needs to be loaded in production.
gem "faker"

group :production do
  # Web application server that replaces webrick. It handles HTTP requests,
  # manages processes and resources, and enables administration, monitoring
  # and problem diagnosis. It is used in production because it gives us an ability
  # to scale by creating additional processes, and will automatically restart any
  # that fail. We don't use it when running tests for speed's sake.
  gem "passenger", "~> 6.0", "!= 6.0.23", "!= 6.0.27", require: "phusion_passenger/rack_handler"
end

group :development, :test do
  # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem "pry-byebug"

  gem "rails-controller-testing"

  # Manages our rubocop style rules for all defra ruby projects
  gem "defra_ruby_style"
  # Shim to load environment variables from a .env file into ENV in development
  # and test
  gem "dotenv-rails"

  # Project uses RSpec as its test framework
  gem "rspec-rails"
end

group :development do
  gem "rubocop-capybara"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-commands-rspec"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console"
  gem "webrick"
end

group :test do
  # Database Cleaner is a set of strategies for cleaning your database in Ruby.
  gem "database_cleaner"
  # Generates a test coverage report on every `bundle exec rspec` call. We use
  # the output to feed CodeClimate's stats and analysis
  gem "simplecov", "~> 0.22.0", require: false
  # Integration testing tool
  gem "capybara"
  # Needed for headless testing with Javascript
  gem "selenium-webdriver"
  # A gem providing "time travel" and "time freezing" capabilities, making it
  # dead simple to test time-dependent code.
  gem "timecop"
  # Mock HTTP requests
  gem "vcr"
  gem "webmock"

  # Allow automated testing of the whenever schedule
  gem "whenever-test"

  # Use Bullet to find unoptimised queries
  gem "bullet"
end
