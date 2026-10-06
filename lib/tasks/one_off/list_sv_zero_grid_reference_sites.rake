# frozen_string_literal: true

namespace :one_off do
  desc "List SV 00000 00000 sites with their registration state and the action needed by NCCC (read-only)"
  task list_sv_zero_grid_reference_sites: :environment do
    addresses = WasteExemptionsEngine::Address.site.where(
      "REGEXP_REPLACE(UPPER(grid_reference), '[[:space:]]+', '', 'g') = 'SV0000000000'"
    ).includes(:registration_exemptions, registration: :registration_exemptions)

    rows = addresses.filter_map do |address|
      registration = address.registration
      next unless registration

      site_active = if registration.multisite?
                      address.registration_exemptions.any?(&:active?)
                    else
                      registration.active?
                    end
      action = if address.postcode.present? && address.uprn.present?
                 "Fix in back office using the address finder"
               else
                 "Contact customer for the site location"
               end

      [registration.reference, registration.state, site_active ? "yes" : "no", action]
    end

    puts "registration,registration_state,site_active,action"
    rows.sort_by { |row| [row[2] == "yes" ? 0 : 1, row[0]] }.each { |row| puts row.join(",") }
  end
end
