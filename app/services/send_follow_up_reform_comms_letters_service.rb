# frozen_string_literal: true

# RUBY-4593: Sends the follow-up reform comms letter once to each unique contact name and address on an active
# registration whose follow-up reform comms email was not delivered
class SendFollowUpReformCommsLettersService < ReformCommsLettersSender
  UNIQUE_REFERENCE_LENGTH = 6
  UNIQUE_REFERENCE_CHARACTERS = [*"A".."Z", *"0".."9"].freeze
  # unique reference regexp
  POSSIBLE_REFERENCE = /\b[A-Z0-9]{#{UNIQUE_REFERENCE_LENGTH}}\b/

  private

  def letter_service
    FollowUpReformCommsLetterService
  end

  # Leaves out a registration whose follow-up email was later delivered, after NCCC corrected the address
  def candidate_registrations
    WasteExemptionsEngine::Registration
      .with_current_exemptions
      .where(id: registration_ids_with_follow_up_email(SendFollowUpReformCommsEmailsService::UNDELIVERED_STATUSES))
      .where.not(id: registration_ids_with_follow_up_email("delivered"))
  end

  # Filtered on the label, as the follow-up email shares its template with the original
  def registration_ids_with_follow_up_email(statuses)
    WasteExemptionsEngine::RegistrationCommunicationLog
      .joins(:communication_log)
      .where(communication_logs: { template_label: FollowUpReformCommsEmailService::TEMPLATE_LABEL,
                                   status: statuses })
      .select(:registration_id)
  end

  def letter_args(letter)
    super.merge(unique_reference: next_unique_reference)
  end

  def next_unique_reference
    loop do
      reference = SecureRandom.alphanumeric(UNIQUE_REFERENCE_LENGTH, chars: UNIQUE_REFERENCE_CHARACTERS)
      return reference if used_references.add?(reference)
    end
  end

  # References sent in earlier runs are only kept in the letter bodies Notify returned. A letter Notify
  # rejected has no body, but its reference never reached anyone.
  def used_references
    @used_references ||= WasteExemptionsEngine::CommunicationLog
                         .where(template_id: FollowUpReformCommsLetterService::TEMPLATE_ID)
                         .where.not(body: nil)
                         .distinct
                         .pluck(:body)
                         .flat_map { |body| body.scan(POSSIBLE_REFERENCE) }
                         .to_set
  end
end
