# frozen_string_literal: true

module CleanupOrphanPeople
  module_function

  def cleanup_orphan_people(dry_run: false)
    orphans = WasteExemptionsEngine::Person.where(registration_id: nil)
    ids = orphans.pluck(:id)

    prefix = dry_run ? "[DRY RUN] Would delete" : "Deleting"
    puts "#{prefix} orphan person IDs: #{ids.join(', ')}" unless Rails.env.test? || ids.empty?

    WasteExemptionsEngine::Person.where(id: ids).delete_all unless dry_run
    ids.length
  end
end

namespace :one_off do
  # rake one_off:cleanup_orphan_people[live-run] to perform actual deletions,
  # otherwise runs in dry-run mode by default
  desc "Remove orphan people with no associated registration"
  task :cleanup_orphan_people, [:mode] => [:environment] do |_task, args|
    dry_run = args[:mode] != "live-run"

    puts "[DRY RUN] No records will be modified" if dry_run && !Rails.env.test?

    orphan_count = CleanupOrphanPeople.cleanup_orphan_people(dry_run: dry_run)
    puts "Orphan people #{dry_run ? 'to delete' : 'deleted'}: #{orphan_count}" unless Rails.env.test?
  end
end
