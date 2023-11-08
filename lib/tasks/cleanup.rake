# frozen_string_literal: true

namespace :cleanup do
  desc "Remove old transient_registrations from the database"
  task :transient_registrations, [:limit] => [:environment] do |_task, args|
    limit = args[:limit]
    TransientRegistrationCleanupService.run(limit: limit)
  end
end

namespace :cleanup do
  desc "Remove expired registrations older than 7 years from the database"
  task remove_expired_registrations: :environment do
    ExpiredRegistrationCleanupService.run
  end
end
