# frozen_string_literal: true

namespace :one_off do
  desc "Delete all transient registrations"
  # Task added for one off use before wex charging go live
  task delete_all_transient_registrations: :environment do
    WasteExemptionsEngine::TransientRegistration.destroy_all
  end
end
