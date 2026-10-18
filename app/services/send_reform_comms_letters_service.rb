# frozen_string_literal: true

require "notifications/client"

# Sends the reform comms letter once to each unique contact name and address on an active
# registration with no contact email, skipping registrations already sent it. Sends at most
# batch_size letters per run, so re-run to send the rest.
class SendReformCommsLettersService < WasteExemptionsEngine::BaseService
  DEFAULT_BATCH_SIZE = 1_000
  # Notify needs at least 3 address lines, and the contact name is the first
  MINIMUM_ADDRESS_LINES = 2

  def run(batch_size: DEFAULT_BATCH_SIZE, dry_run: false)
    @dry_run = dry_run
    @result = { letters_sent: 0, registrations_covered: 0, letters: [], failed: [], unsendable: [],
                letters_remaining: 0, rate_limited: false }

    groups = recipient_groups
    groups.first(batch_size).each do |group|
      send_letter(group)
    rescue Notifications::Client::RateLimitError => e
      handle_rate_limit(e)
      break
    rescue Notifications::Client::BadRequestError => e
      add_unsendable(group, e.message)
    rescue StandardError => e
      handle_failure(group, e)
    end

    @result[:letters_remaining] = groups.size - @result[:letters_sent]
    @result
  end

  private

  # Recipients sharing a contact name and address, in order of registration id.
  def recipient_groups
    sendable_recipients
      .group_by { |recipient| recipient_key(recipient) }
      .values
      .sort_by { |group| group.map(&:id).min }
  end

  def sendable_recipients
    recipients = registrations_to_send.map { |registration| ReformCommsLetterRecipientPresenter.new(registration) }
    unsendable, sendable = recipients.partition { |recipient| unsendable_reason(recipient) }
    unsendable.each { |recipient| add_unsendable([recipient], unsendable_reason(recipient)) }
    sendable
  end

  def registrations_to_send
    WasteExemptionsEngine::Registration
      .with_current_exemptions
      .contact_email_not_present
      .where.not(id: already_sent_registration_ids)
      .includes(:contact_address)
      .order(:id)
  end

  def already_sent_registration_ids
    WasteExemptionsEngine::RegistrationCommunicationLog
      .joins(:communication_log)
      .where(communication_logs: { template_id: ReformCommsLetterService::TEMPLATE_ID })
      .select(:registration_id)
  end

  def unsendable_reason(recipient)
    if recipient.contact_address.blank?
      "no contact address"
    elsif recipient.contact_address.postcode.blank?
      "no contact address postcode"
    elsif recipient.address_lines.size < MINIMUM_ADDRESS_LINES
      "too few contact address lines"
    end
  end

  # Recipients whose names and address lines match (case and whitespace aside) share a letter
  def recipient_key(recipient)
    [recipient.first_name, recipient.last_name, *recipient.address_lines]
      .map { |value| value.delete(" ").downcase }
  end

  def send_letter(group)
    recipient = group.min_by(&:id)

    unless @dry_run
      ReformCommsLetterService.run(first_name: recipient.first_name, last_name: recipient.last_name,
                                   address_lines: recipient.address_lines, registrations: group.map(&:model))
    end

    add_letter(group, recipient)
  end

  def add_letter(group, recipient)
    @result[:letters_sent] += 1
    @result[:registrations_covered] += group.size
    @result[:letters] << { references: group.map(&:reference), recipient: recipient.recipient }
  end

  def add_unsendable(group, reason)
    Rails.logger.warn "Reform comms letter not sendable for registrations #{references(group)}: #{reason}"
    @result[:unsendable] << { references: group.map(&:reference), reason: }
  end

  def handle_rate_limit(error)
    Airbrake.notify error
    Rails.logger.error "Stopped sending reform comms letters, Notify limit exceeded: #{error.message}."
    @result[:rate_limited] = true
  end

  def handle_failure(group, error)
    Airbrake.notify error, registration: references(group)
    Rails.logger.error "Failed to send reform comms letter for registrations #{references(group)}"
    @result[:failed] << { references: group.map(&:reference), error: error.message }
  end

  def references(group)
    group.map(&:reference).join(", ")
  end
end
