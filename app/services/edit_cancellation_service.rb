# frozen_string_literal: true

class EditCancellationService < WasteExemptionsEngine::BaseService
  def run(edit_registration:)
    @edit_registration = edit_registration
    @edit_registration.destroy
  end
end
