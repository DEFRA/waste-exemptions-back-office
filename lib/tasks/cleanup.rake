# frozen_string_literal: true

namespace :cleanup do
  desc "Remove old transient_registrations from the database"
  task transient_registrations: :environment do
    limit = ENV.fetch("TRANSIENT_REGISTRATION_CLEANUP_LIMIT", 100_000).to_i
    TransientRegistrationCleanupService.run(limit: limit)
  end

  desc "Remove old placeholder registrations from the database"
  task placeholder_registrations: :environment do
    # We use the same limit setting as the transient registration cleanup task.
    limit = ENV.fetch("TRANSIENT_REGISTRATION_CLEANUP_LIMIT", 100_000).to_i
    PlaceholderRegistrationCleanupService.run(limit: limit)
  end

  desc "Remove expired registrations older than 7 years from the database"
  task remove_expired_registrations: :environment do
    ExpiredRegistrationCleanupService.run
  end
end
