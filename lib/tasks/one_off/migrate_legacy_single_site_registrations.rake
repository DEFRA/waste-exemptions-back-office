# frozen_string_literal: true

namespace :one_off do
  desc "Migrate legacy single_site registrations to the multi_site model"
  task :migrate_legacy_single_site_registrations, [:batch_size] => [:environment] do |_task, args|
    batch_size = (args[:batch_size] || 1_000).to_i

    loop do
      start_time = Time.zone.now

      site_addresses = address_scope(batch_size)
      break if site_addresses.empty?

      puts "Batch limit #{batch_size}; migrating #{site_addresses.length} addresses" unless Rails.env.test?
      site_addresses.each do |site_address|
        next unless site_address.registration_exemptions.empty?
        next if site_address.registration.registration_exemptions.empty?

        site_address.update(registration_exemptions: site_address.registration.registration_exemptions)
      end

      finish_time = Time.zone.now
      duration = (finish_time - start_time)
      rate_per_k = (1000 * duration / site_addresses.length).round(1)
      unless Rails.env.test?
        puts "Migration complete after #{duration.round(2)} seconds (#{rate_per_k} seconds per thousand); " \
             "#{qualifying_addresses.length} remaining addresses to migrate."
      end
    end
  end
end

def qualifying_addresses
  registration_ids_with_exemptions = WasteExemptionsEngine::RegistrationExemption
                                     .joins(:registration)
                                     .where(registrations: { is_multisite_registration: [false, nil] })
                                     .pluck(:registration_id)

  WasteExemptionsEngine::Address.where(address_type: 3)
                                .where.missing(:registration_exemptions)
                                .joins(:registration)
                                .where(registration: { id: registration_ids_with_exemptions })
end

def address_scope(batch_size)
  qualifying_addresses
    .includes(registration: :registration_exemptions)
    .limit(batch_size)
end
