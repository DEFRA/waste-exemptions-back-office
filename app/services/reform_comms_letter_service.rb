# frozen_string_literal: true

require "notifications/client"

# Sends one reform comms letter to the given contact and records it in the communication history of
# each of the given registrations. This is for cases where multiple registrations share a contact name
# and address, and a letter needs to be sent only once.
class ReformCommsLetterService < WasteExemptionsEngine::BaseService
  include WasteExemptionsEngine::CanHaveCommunicationLog

  def run(first_name:, last_name:, address_lines:, registrations:)
    @first_name = first_name
    @last_name = last_name
    @address_lines = address_lines
    notify_result = notify_client.send_letter(template_id: self.class::TEMPLATE_ID,
                                              personalisation: personalisation(registrations))
    registrations.each { |registration| create_log(registration:, notify_response: notify_result) }
    notify_result
  rescue Notifications::Client::BadRequestError
    # Notify will reject the letter every time, so record that to stop it being sent again
    registrations.each { |registration| create_rejection_log(registration:) }
    raise
  end

  # For CanHaveCommunicationLog
  def communications_log_params
    {
      message_type: "letter",
      template_id: self.class::TEMPLATE_ID,
      template_label: self.class::TEMPLATE_LABEL,
      sent_to: recipient
    }
  end

  private

  # The client to send through, which decides what accompanies the letter
  def notify_client
    raise NotImplementedError
  end

  # Like CanHaveCommunicationLog#create_log, for a letter Notify rejected
  def create_rejection_log(registration:)
    registration.communication_logs << WasteExemptionsEngine::CommunicationLog.new(
      communications_log_params.merge(status: "permanent-failure")
    )
  end

  def personalisation(_registrations)
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
