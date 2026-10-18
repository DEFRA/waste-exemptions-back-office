# frozen_string_literal: true

require "notifications/client"

# Sends one reform comms letter to the given contact and records it in the communication
# history of each of the given registrations. This is for cases where multiple registrations
# share a contact name and address, and a letter needs to be sent only once.
class ReformCommsLetterService < WasteExemptionsEngine::BaseService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  TEMPLATE_ID = "cdbd027b-aa13-49f2-b904-0fe9ec636958"

  def run(first_name:, last_name:, address_lines:, registrations:)
    @first_name = first_name
    @last_name = last_name
    @address_lines = address_lines
    client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)
    notify_result = client.send_letter(template_id: TEMPLATE_ID, personalisation: personalisation)
    registrations.each { |registration| create_log(registration:, notify_response: notify_result) }
    notify_result
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "letter",
      template_id: TEMPLATE_ID,
      template_label: "Reform comms letter - October 2026",
      sent_to: recipient
    }
  end

  private

  def personalisation
    {
      first_name: @first_name,
      last_name: @last_name
    }.merge(numbered_address_lines)
  end

  def address_values
    ["#{@first_name} #{@last_name}", *@address_lines]
  end

  def numbered_address_lines
    address_values.each_with_index.to_h do |value, index|
      ["address_line_#{index + 1}", value]
    end
  end

  def recipient
    address_values.join(", ")
  end
end
