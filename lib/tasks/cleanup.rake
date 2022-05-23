# frozen_string_literal: true

namespace :cleanup do
  desc "Remove old transient_registrations from the database"
  task transient_registrations: :environment do
    TransientRegistrationCleanupService.run
  end
end

namespace :cleanup do
  desc "Remove expired registrations older than 7 years from the database"
  task old_regsitrations: :environment do
    ExpiredRegistrationCleanupService.run
  end
end
