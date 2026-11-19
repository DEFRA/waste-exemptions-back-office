# frozen_string_literal: true

# Sends the October reform comms email once to each unique contact email on an
# active registration, skipping any already sent.
class SendOctoberReformCommsEmailsService < ReformCommsEmailsSender
  private

  def email_service
    OctoberReformCommsEmailService
  end

  def description
    "reform comms email"
  end

  def candidate_registrations
    WasteExemptionsEngine::Registration
      .with_current_exemptions
      .contact_email_present
      .select(:id, :reference, :contact_email)
      .order(:id)
  end

  def addresses_to_skip
    @addresses_to_skip ||= WasteExemptionsEngine::CommunicationLog
                           .where(template_id: OctoberReformCommsEmailService::TEMPLATE_ID)
                           .pluck(:sent_to)
                           .to_set { |email| normalise(email) }
  end
end
