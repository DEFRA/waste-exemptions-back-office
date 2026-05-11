# frozen_string_literal: true

module WasteExemptionsEngine
  module CanRedirectBackOfficeEditRegistration
    def form_path
      return super unless @transient_registration.is_a?(BackOfficeEditRegistration)

      @transient_registration.save if @transient_registration.token.blank?

      helper_name = :"new_#{@transient_registration.workflow_state}_path"

      if main_app.respond_to?(helper_name)
        main_app.public_send(helper_name, token: @transient_registration.token)
      else
        super
      end
    end
  end
end
