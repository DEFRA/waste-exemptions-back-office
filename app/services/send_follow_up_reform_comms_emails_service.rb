# frozen_string_literal: true

# Sends the reform comms email again, once to each unique contact email on an active registration
# whose earlier one Notify did not deliver, skipping any address already emailed.
class SendFollowUpReformCommsEmailsService < ReformCommsEmailsSender
  UNDELIVERED_STATUSES = %w[permanent-failure temporary-failure technical-failure].freeze

  private

  def email_service
    FollowUpReformCommsEmailService
  end

  def description
    "follow-up reform comms email"
  end

  # Keyed on the contact email the registration holds now, which NCCC may have corrected
  def candidate_registrations
    WasteExemptionsEngine::Registration
      .with_current_exemptions
      .contact_email_present
      .where(id: registration_ids_with_undelivered_email)
      .select(:id, :reference, :contact_email)
      .order(:id)
  end

  def registration_ids_with_undelivered_email
    WasteExemptionsEngine::RegistrationCommunicationLog
      .joins(:communication_log)
      .where(communication_logs: { template_id: FollowUpReformCommsEmailService::TEMPLATE_ID,
                                   status: UNDELIVERED_STATUSES })
      .select(:registration_id)
  end

  def addresses_to_skip
    @addresses_to_skip ||= (delivered_addresses + followed_up_addresses).to_set
  end

  def delivered_addresses
    normalised_addresses(
      WasteExemptionsEngine::CommunicationLog
        .where(template_id: FollowUpReformCommsEmailService::TEMPLATE_ID, status: "delivered")
    )
  end

  def followed_up_addresses
    normalised_addresses(
      WasteExemptionsEngine::CommunicationLog
        .where(template_label: FollowUpReformCommsEmailService::TEMPLATE_LABEL)
    )
  end

  def normalised_addresses(communication_logs)
    communication_logs.pluck(:sent_to).map { |email| normalise(email) }
  end
end
