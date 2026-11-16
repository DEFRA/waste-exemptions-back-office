# frozen_string_literal: true

require "notifications/client"

# Sends the reform comms email again, once to each unique contact email on an active registration
# whose earlier one Notify did not deliver, skipping any address already emailed. A dry run lists
# each email and its registrations on the output, and every run ends with the totals.
class SendFollowUpReformCommsEmailsService < WasteExemptionsEngine::BaseService
  # Notify's limit is shared with the service's other emails
  RATE_LIMIT = 3_000
  RATE_LIMIT_BUFFER = 0.5
  TIME_BETWEEN_BATCHES = 60 # seconds

  UNDELIVERED_STATUSES = %w[permanent-failure temporary-failure technical-failure].freeze

  def run(dry_run: false, output: $stdout)
    @dry_run = dry_run
    sent_count = 0
    registration_count = 0

    registrations_by_email.each_with_index do |(email, registrations), index|
      wait_for_next_batch if (index % batch_size).zero?
      send_email(email, registrations)
      output.puts "#{email} (#{registrations.size}): #{references(registrations)}" if @dry_run
      sent_count += 1
      registration_count += registrations.size
    rescue Notifications::Client::RateLimitError => e
      Airbrake.notify e
      Rails.logger.error "Stopped sending follow-up reform comms emails as Notify rejected one for " \
                         "exceeding a limit: #{e.message}. Re-run to send the rest."
      break
    rescue StandardError => e
      Airbrake.notify e, registration: references(registrations)
      Rails.logger.error "Failed to send follow-up reform comms email for registrations #{references(registrations)}"
    end

    output_totals(output, sent_count, registration_count)

    sent_count
  end

  private

  def output_totals(output, sent_count, registration_count)
    output.puts "Follow-up reform comms emails #{@dry_run ? 'to send' : 'sent'}: #{sent_count}",
                "Registrations covered: #{registration_count}"
  end

  def send_email(email, registrations)
    prefix = @dry_run ? "[DRY RUN] Would send" : "Sending"
    Rails.logger.info "#{prefix} follow-up reform comms email for #{references(registrations)}"

    FollowUpReformCommsEmailService.run(email:, registrations:) unless @dry_run
  end

  def batch_size
    (RATE_LIMIT * RATE_LIMIT_BUFFER).to_i
  end

  # Waits until a minute has passed since the previous batch started
  def wait_for_next_batch
    return if @dry_run

    now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    sleep(@next_batch_at - now) if @next_batch_at && @next_batch_at > now
    @next_batch_at = Process.clock_gettime(Process::CLOCK_MONOTONIC) + TIME_BETWEEN_BATCHES
  end

  def registrations_by_email
    registrations_to_follow_up
      .group_by { |registration| normalise(registration.contact_email) }
      .reject { |email, _registrations| email.blank? || addresses_to_skip.include?(email) }
  end

  # Keyed on the contact email the registration holds now, which NCCC may have corrected
  def registrations_to_follow_up
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

  def references(registrations)
    registrations.map(&:reference).join(", ")
  end

  def normalise(email)
    email.to_s.strip.downcase
  end
end
