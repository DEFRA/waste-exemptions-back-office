# frozen_string_literal: true

# Require this to support automatically cleaning the database when testing
require "database_cleaner"

RSpec.configure do |config|
  # Clean the database before running tests. Setup as per
  # https://github.com/DatabaseCleaner/database_cleaner#rspec-example
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    # Add retry logic to handle potential connection issues in CI
    retries = 0
    begin
      DatabaseCleaner.cleaning do
        example.run
      end
    rescue IOError => e
      raise e unless e.message.include?("stream closed in another thread") && retries < 3

      retries += 1
      ActiveRecord::Base.connection_pool.disconnect!
      ActiveRecord::Base.connection_pool.clear_reloadable_connections!
      retry
    end
  end
end
