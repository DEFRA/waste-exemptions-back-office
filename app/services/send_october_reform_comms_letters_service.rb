# frozen_string_literal: true

# Sends the October reform comms letter once to each unique contact name and address on an
# active registration with no contact email, skipping registrations to which it was already sent.
class SendOctoberReformCommsLettersService < ReformCommsLettersSender
  private

  def letter_service
    OctoberReformCommsLetterService
  end

  def candidate_registrations
    WasteExemptionsEngine::Registration
      .with_current_exemptions
      .contact_email_not_present
  end
end
