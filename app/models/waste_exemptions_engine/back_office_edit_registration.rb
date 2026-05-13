# frozen_string_literal: true

module WasteExemptionsEngine
  class BackOfficeEditRegistration < TransientRegistration
    include ::CanUseEditRegistrationWorkflow
    include CanCopyDataFromRegistration

    private

    def default_workflow_state
      "edit_form"
    end
  end
end
