# frozen_string_literal: true

# RUBY-4593: Sends the reform comms letter to a contact whose follow-up email was not delivered. The letter lists
# the registrations it covers and a unique reference the operator can quote to NCCC when asking to
# update their contact details.
class FollowUpReformCommsLetterService < ReformCommsLetterService
  TEMPLATE_ID = "4e748e2f-de10-4ce9-9fac-6dfdd6ab57f8"
  TEMPLATE_LABEL = "Reform comms follow-up letter - November 2026"

  def run(unique_reference:, **letter_args)
    @unique_reference = unique_reference

    super(**letter_args)
  end

  private

  # Sends the unique reference as the Notify reference too, so the letter can be found by it in Notify
  def notify_client
    WasteExemptionsEngine::NotifyClient.new(reference: @unique_reference)
  end

  def personalisation(registrations)
    super.merge(
      unique_reference: @unique_reference,
      registration_numbers: registrations.map(&:reference).join(", ")
    )
  end
end
