# frozen_string_literal: true

namespace :one_off do
  # rake one_off:cleanup_duplicate_addresses[live-run] to perform actual deletions,
  # otherwise runs in dry-run mode by default
  desc "Remove duplicate addresses from registrations (keeps addresses with exemptions, deletes those without)"
  task :cleanup_duplicate_addresses, [:mode] => [:environment] do |_task, args|
    dry_run = args[:mode] != "live-run"
    total_deleted = 0

    puts "[DRY RUN] No records will be modified" if dry_run && !Rails.env.test?

    # Process each address type: operator (1), contact (2), site (3)
    WasteExemptionsEngine::Address.address_types.each do |type_name, type_value|
      next if type_value.zero? # skip unknown

      duplicate_groups = find_duplicate_groups(type_name, type_value)
      next if duplicate_groups.empty?

      unless Rails.env.test?
        puts "Processing #{duplicate_groups.length} registrations with duplicate #{type_name} addresses"
      end

      duplicate_groups.each do |registration_id, address_ids|
        deleted = deduplicate_address_group(registration_id, address_ids, dry_run: dry_run)
        total_deleted += deleted
      end
    end

    puts "Total addresses #{dry_run ? 'to delete' : 'deleted'}: #{total_deleted}" unless Rails.env.test?
  end
end

def find_duplicate_groups(type_name, type_value)
  scope = WasteExemptionsEngine::Address.where(address_type: type_value).where.not(registration_id: nil)

  # For site addresses, exclude legitimate multisite registrations
  if type_name == "site"
    multisite_registration_ids = WasteExemptionsEngine::Registration
                                 .where(is_multisite_registration: true)
                                 .pluck(:id)
    scope = scope.where.not(registration_id: multisite_registration_ids) if multisite_registration_ids.any?
  end

  scope.group(:registration_id)
       .having("COUNT(*) > 1")
       .pluck(:registration_id, Arel.sql("ARRAY_AGG(id ORDER BY id)"))
       .to_h
end

# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
def deduplicate_address_group(registration_id, address_ids, dry_run: false)
  addresses = WasteExemptionsEngine::Address.where(id: address_ids)
  # double check all addresses belong to same registration
  return 0 if addresses.pluck(:registration_id).uniq != [registration_id]
  # double check all addresses belong to the same type
  return 0 if addresses.pluck(:address_type).uniq.count != 1

  with_exemptions = address_ids.select do |id|
    WasteExemptionsEngine::RegistrationExemption.exists?(address_id: id)
  end

  without_exemptions = address_ids - with_exemptions

  ids_to_delete = if with_exemptions.any?
                    # Keep addresses that have exemptions, delete the rest
                    without_exemptions
                  else
                    # No exemptions on any duplicate — keep the first (lowest id), delete the rest
                    address_ids[1..]
                  end

  return 0 if ids_to_delete.empty?

  prefix = dry_run ? "[DRY RUN] Would delete" : "Deleting"
  puts "#{prefix} addresses #{ids_to_delete.join(', ')} for registration #{registration_id}" unless Rails.env.test?

  unless dry_run
    ActiveRecord::Base.transaction do
      WasteExemptionsEngine::Address.where(id: ids_to_delete).destroy_all
    end
  end

  ids_to_delete.length
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
