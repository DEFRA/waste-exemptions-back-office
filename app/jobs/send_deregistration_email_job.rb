# frozen_string_literal: true

class SendDeregistrationEmailJob < ApplicationJob
  def perform(registration_id)
    ActiveRecord::Base.transaction do
      registration = WasteExemptionsEngine::Registration.find(registration_id)

      next unless registration.deregistration_email_sent_at.nil?

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

      registration.update!(deregistration_email_sent_at: Time.zone.now)
    end
  end
end
