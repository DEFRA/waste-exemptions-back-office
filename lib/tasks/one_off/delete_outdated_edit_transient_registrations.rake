# frozen_string_literal: true

namespace :one_off do
  desc "Delete all transient registrations with a type of WasteExemptionsEngine::EditRegistration"
  task delete_outdated_edit_transient_registrations: :environment do
    # Use raw SQL to bypass STI mechanism
    ActiveRecord::Base.connection.execute(
      "DELETE FROM transient_registrations WHERE type = 'WasteExemptionsEngine::EditRegistration'"
    )
    puts "Deleted all transient registrations with a type of WasteExemptionsEngine::EditRegistration"
  end
end
