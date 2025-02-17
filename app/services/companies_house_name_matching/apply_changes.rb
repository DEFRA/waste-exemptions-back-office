# frozen_string_literal: true

module CompaniesHouseNameMatching
  class ApplyChanges < WasteExemptionsEngine::BaseService

    def run(proposed_changes = {})
      raise ArgumentError, "proposed_changes must be a Hash" unless proposed_changes.is_a?(Hash)

      ActiveRecord::Base.transaction do
        proposed_changes.each_value do |changes|
          changes.each do |reference, _old_name, new_name|
            registration = WasteExemptionsEngine::Registration.find_by(reference: reference)
            registration.update!(operator_name: new_name)
          end
        end
      end
    end
  end
end
