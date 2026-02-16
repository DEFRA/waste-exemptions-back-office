# frozen_string_literal: true

namespace :one_off do
  # rake one_off:cleanup_orphan_addresses[live-run] to perform actual deletions,
  # otherwise runs in dry-run mode by default
  desc "Remove orphan addresses and transient addresses with no associated registration"
  task :cleanup_orphan_addresses, [:mode] => [:environment] do |_task, args|
    dry_run = args[:mode] != "live-run"

    puts "[DRY RUN] No records will be modified" if dry_run && !Rails.env.test?

    orphan_address_count = cleanup_orphan_addresses(dry_run: dry_run)
    puts "Orphan addresses #{dry_run ? 'to delete' : 'deleted'}: #{orphan_address_count}" unless Rails.env.test?

    orphan_count = cleanup_orphan_transient_addresses(dry_run: dry_run)
    puts "Orphan transient_addresses #{dry_run ? 'to delete' : 'deleted'}: #{orphan_count}" unless Rails.env.test?
  end
end

def cleanup_orphan_addresses(dry_run: false)
  orphans = WasteExemptionsEngine::Address.where(registration_id: nil)
  safe_to_delete = orphans.where.missing(:registration_exemptions)
  ids = safe_to_delete.pluck(:id)

  unless Rails.env.test? || ids.empty?
    prefix = dry_run ? "[DRY RUN] Would delete" : "Deleting"
    puts "#{prefix} orphan address IDs: #{ids.join(', ')}"
  end

  WasteExemptionsEngine::Address.where(id: ids).delete_all unless dry_run
  ids.length
end

def cleanup_orphan_transient_addresses(dry_run: false)
  orphans = WasteExemptionsEngine::TransientAddress.where(transient_registration_id: nil)
  ids = orphans.pluck(:id)

  unless Rails.env.test? || ids.empty?
    prefix = dry_run ? "[DRY RUN] Would delete" : "Deleting"
    puts "#{prefix} orphan transient_address IDs: #{ids.join(', ')}"
  end

  WasteExemptionsEngine::TransientAddress.where(id: ids).delete_all unless dry_run
  ids.length
end
