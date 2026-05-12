# frozen_string_literal: true

class EditRegistration < WasteExemptionsEngine::TransientRegistration
  include CanUseEditRegistrationWorkflow
  include WasteExemptionsEngine::CanCopyDataFromRegistration

  private

  def default_workflow_state
    "edit_form"
  end
end
