# frozen_string_literal: true

class SendDeregistrationEmailJob < ApplicationJob
  def perform(registration_id)
    ActiveRecord::Base.transaction do
      registration = WasteExemptionsEngine::Registration.find(registration_id)

      next if registration.received_comms?(I18n.t("template_labels.deregistration_invitation_email"))

      DeregistrationEmailService.run(
        registration: registration,
        recipient: registration.contact_email
      )

      if registration.contact_email != registration.applicant_email
        DeregistrationEmailService.run(
          registration: registration,
          recipient: registration.applicant_email
        )
      end
    end
  end
end
