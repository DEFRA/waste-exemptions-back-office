# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
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

  desc "Identify registrations with no registration_exemptions or no site addresses"
  task identify_registrations_without_exemptions_or_sites: :environment do
    rows = IdentifyRegistrationsWithoutExemptionsOrSitesService.run

    unless Rails.env.test?
      # :nocov:
      puts "Found #{rows.length} registration(s) with no exemptions or no sites \n\n"
      puts CommandLineTableFormatter.new(rows).render if rows.any?
      # :nocov:
    end
  end

  desc "Delete a registration by reference (e.g. WEX000123), only if it has no exemptions"
  task :delete_registration, [:reference] => :environment do |_task, args|
    reference = args[:reference].to_s.strip
    outcome = DeleteRegistrationWithoutExemptionsService.run(reference: reference)

    unless Rails.env.test?
      # :nocov:
      message = case outcome
                when :deleted then "Deleted registration #{reference}"
                when :has_exemptions then "Registration #{reference} has exemptions - not deleting"
                else "No registration found with reference #{reference.inspect}"
                end
      puts message
      # :nocov:
    end
  end
end
# rubocop:enable Metrics/BlockLength
