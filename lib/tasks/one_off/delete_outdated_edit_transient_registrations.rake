# frozen_string_literal: true

namespace :one_off do
  desc "Delete all transient registrations with a type of WasteExemptionsEngine::EditRegistration"
  task delete_outdated_edit_transient_registrations: :environment do
    # Use raw SQL to bypass STI mechanism
    connection = ActiveRecord::Base.connection

    sql = "SELECT id FROM transient_registrations WHERE type = 'WasteExemptionsEngine::EditRegistration';"
    outdated_registration_ids = connection.execute(sql).pluck("id")

    # First, delete all associated transient_addresses, transient_people, and transient_registration_exemptions

    WasteExemptionsEngine::TransientAddress
      .where(transient_registration_id: outdated_registration_ids)
      .destroy_all

    WasteExemptionsEngine::TransientPerson
      .where(transient_registration_id: outdated_registration_ids)
      .destroy_all

    WasteExemptionsEngine::TransientRegistrationExemption
      .where(transient_registration_id: outdated_registration_ids)
      .destroy_all

    # Now, delete the transient registrations
    sql = <<-SQL.squish
      DELETE FROM transient_registrations
      WHERE id IN (#{outdated_registration_ids.join(', ')});
    SQL

    ActiveRecord::Base.connection.execute(sql)

    puts "Deleted all transient registrations with a type of " \
         "WasteExemptionsEngine::EditRegistration and their associated " \
         "transient addresses / transient people"
  end
end
