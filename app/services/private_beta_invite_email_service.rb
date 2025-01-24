# frozen_string_literal: true

require "notifications/client"

class PrivateBetaInviteEmailService < WasteExemptionsEngine::BaseService
  # So we can use displayable_address()
  include WasteExemptionsEngine::ApplicationHelper
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(registration:, beta_participant:)
    @registration = registration
    @beta_participant = beta_participant

    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

    notify_result = client.send_email(email_address: recipient_email,
                                      template_id: template,
                                      personalisation: personalisation)

    update_invited_at_time

    create_log(registration:)

    notify_result
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "email",
      template_id: template,
      template_label: "Private beta invite email",
      sent_to: recipient_email
    }
  end

  private

  def template
    "6d4a8a47-bf39-4299-ab44-1f00b0d9370b"
  end

  def recipient_email
    @registration.contact_email
  end

  def contact_name
    "#{@registration.contact_first_name} #{@registration.contact_last_name}"
  end

  def exemptions
    relevant_exemptions = @registration.registration_exemptions.order(:exemption_id).select do |re|
      re.may_expire? || re.expired?
    end
    relevant_exemptions.map { |ex| "#{ex.exemption.code} #{ex.exemption.summary}" }
  end

  def personalisation
    {
      contact_name: contact_name,
      exemptions: exemptions,
      private_beta_start_url: @beta_participant.private_beta_start_url
    }
  end

  def update_invited_at_time
    @beta_participant.update(invited_at: Time.current)
  end
end
