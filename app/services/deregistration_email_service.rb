# frozen_string_literal: true

require "notifications/client"

class DeregistrationEmailService < RenewalReminderEmailService
  attr_reader :registration, :recipient

  def run(registration:, recipient:)
    @registration = registration
    @recipient = recipient

    send!
  end

  private

  def send!
    client.send_email(
      email_address: recipient,
      template_id: template,
      personalisation: personalisation
    )
  end

  def client
    @client ||= Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)
  end

  def personalisation
    {
      contact_name: contact_name,
      magic_link_url: magic_link_url,
      reference: @registration.reference,
      site_details: site_location,
      exemption_details: exemptions
    }
  end

  def template
    "9148895b-e239-4118-8ffd-dadd9b2cf462"
  end
end
