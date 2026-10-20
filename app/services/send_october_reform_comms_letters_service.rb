# frozen_string_literal: true

require "notifications/client"

# Sends the October reform comms letter once to each unique contact name and address on an
# active registration with no contact email, skipping registrations to which it was already sent.
# Sends at most batch_size letters per run.
#
# A recipient is the contact name and address of one registration. A letter goes to one
# recipient and covers every registration whose recipient matches.
class SendOctoberReformCommsLettersService < WasteExemptionsEngine::BaseService
  DEFAULT_BATCH_SIZE = 1_000
  # Notify needs at least 3 address lines, and the contact name is the first
  MINIMUM_ADDRESS_LINES = 2

  # A letter's recipient and the registrations it covers
  Letter = Struct.new(:recipient, :registrations)

  def run(batch_size: DEFAULT_BATCH_SIZE, dry_run: false)
    @dry_run = dry_run
    @result = { letters_sent: 0, registrations_covered: 0, letters: [], failed: [], unsendable: [],
                letters_remaining: 0, rate_limited: false }

    letters = letters_to_send
    letters_rejected = 0
    letters.first(batch_size).each do |letter|
      send_letter(letter)
    rescue Notifications::Client::RateLimitError => e
      record_rate_limit(e)
      break
    rescue Notifications::Client::BadRequestError => e
      letters_rejected += 1
      record_unsendable(letter.registrations, e.message)
    rescue StandardError => e
      record_failure(letter, e)
    end

    # Rejected letters are recorded in the communication history, so later runs skip them
    @result[:letters_remaining] = letters.size - @result[:letters_sent] - letters_rejected
    @result
  end

  private

  # One letter per matching recipient, addressed using the first of them
  def letters_to_send
    addressable_recipients
      .group_by { |recipient| matching_key(recipient) }
      .values
      .map { |recipients| Letter.new(recipients.first, recipients.map(&:model)) }
  end

  # Recipients whose contact address can be used for a letter. The rest are recorded as unsendable.
  def addressable_recipients
    recipients = eligible_registrations.map do |registration|
      OctoberReformCommsLetterRecipientPresenter.new(registration)
    end

    recipients.reject do |recipient|
      problem = address_problem(recipient)
      next false if problem.blank?

      record_unsendable([recipient.model], problem)
      true
    end
  end

  # Active registrations with no contact email that don't yet have the letter in their
  # communication history, as sent or as rejected by Notify
  def eligible_registrations
    WasteExemptionsEngine::Registration
      .with_current_exemptions
      .contact_email_not_present
      .where.not(id: registration_ids_with_letter_in_history)
      .includes(:contact_address)
  end

  def registration_ids_with_letter_in_history
    WasteExemptionsEngine::RegistrationCommunicationLog
      .joins(:communication_log)
      .where(communication_logs: { template_id: OctoberReformCommsLetterService::TEMPLATE_ID })
      .select(:registration_id)
  end

  # Why the recipient's contact address can't be used for a letter, or nil if it can
  def address_problem(recipient)
    if recipient.contact_address.blank?
      "no contact address"
    elsif recipient.contact_address.postcode.blank?
      "no contact address postcode"
    elsif recipient.address_lines.size < MINIMUM_ADDRESS_LINES
      "too few contact address lines"
    end
  end

  # Recipients whose names and address lines match (case and whitespace aside) will share a letter
  def matching_key(recipient)
    [recipient.first_name, recipient.last_name, *recipient.address_lines]
      .map { |value| value.delete(" ").downcase }
  end

  def send_letter(letter)
    recipient = letter.recipient

    unless @dry_run
      OctoberReformCommsLetterService.run(first_name: recipient.first_name, last_name: recipient.last_name,
                                          address_lines: recipient.address_lines,
                                          registrations: letter.registrations)
    end

    record_sent(letter)
  end

  def record_sent(letter)
    @result[:letters_sent] += 1
    @result[:registrations_covered] += letter.registrations.size
    @result[:letters] << { references: letter.registrations.map(&:reference),
                           recipient: letter.recipient.name_and_address }
  end

  def record_unsendable(registrations, reason)
    Rails.logger.warn "Reform comms letter not sendable for registrations #{references(registrations)}: #{reason}"
    @result[:unsendable] << { references: registrations.map(&:reference), reason: }
  end

  def record_rate_limit(error)
    Airbrake.notify error
    Rails.logger.error "Stopped sending reform comms letters, Notify limit exceeded: #{error.message}."
    @result[:rate_limited] = true
  end

  def record_failure(letter, error)
    Airbrake.notify error, registration: references(letter.registrations)
    Rails.logger.error "Failed to send reform comms letter for registrations #{references(letter.registrations)}"
    @result[:failed] << { references: letter.registrations.map(&:reference), error: error.message }
  end

  def references(registrations)
    registrations.map(&:reference).join(", ")
  end
end
