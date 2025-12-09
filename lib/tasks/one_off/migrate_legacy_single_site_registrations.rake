# frozen_string_literal: true

namespace :one_off do
  desc "Migrate legacy single_site registrations to the multi_site model"
  task :migrate_legacy_single_site_registrations, [:batch_size] => [:environment] do |_task, args|
    batch_size = (args[:batch_size] || 1_000).to_i

    qualifying_addresses.in_batches(of: batch_size, load: true) do |batch|
      start_time = Time.zone.now

      puts "Migrating batch of #{batch.length} addresses" unless Rails.env.test?

      ActiveRecord::Base.transaction do
        # rubocop:disable Rails/SkipsModelValidations
        batch.each do |site_address|
          WasteExemptionsEngine::RegistrationExemption
            .where(registration_id: site_address.registration_id, address_id: nil)
            .update_all(address_id: site_address.id)
        end
        # rubocop:enable Rails/SkipsModelValidations
      end

      next if Rails.env.test?

      duration = (Time.zone.now - start_time).round(2)
      rate_per_k = (1000 * duration / batch.length).round(1)
      remaining = qualifying_addresses.count
      puts "Batch complete in #{duration}s (#{rate_per_k}s per 1000); #{remaining} remaining"
    end
  end
end

def qualifying_addresses
  registration_ids_with_exemptions = WasteExemptionsEngine::RegistrationExemption
                                     .joins(:registration)
                                     .where(registrations: { is_multisite_registration: [false, nil] })
                                     .pluck(:registration_id).uniq

  WasteExemptionsEngine::Address.where(address_type: 3)
                                .where.missing(:registration_exemptions)
                                .where(registration_id: registration_ids_with_exemptions)
end
