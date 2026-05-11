# frozen_string_literal: true

module WasteExemptionsEngine
  class EditPermissionCheckerService < WasteExemptionsEngine::BaseService
    def run(current_user:)
      Ability.new(current_user).authorize!(:update, WasteExemptionsEngine::Registration.new)
    end
  end
end
