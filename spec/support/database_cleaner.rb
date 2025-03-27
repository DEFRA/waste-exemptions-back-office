# frozen_string_literal: true

# Require this to support automatically cleaning the database when testing
require "database_cleaner"

RSpec.configure do |config|
  # Clean the database before running tests
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Use transaction strategy by default
  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
