# frozen_string_literal: true

require "notifications/client"

# Sends the October reform comms email once to each unique contact email on an
# active registration, skipping any already sent. A dry run lists each email and its registrations on the output, and every run ends
# with the totals.
class SendOctoberReformCommsEmailsService < WasteExemptionsEngine::BaseService
  # Notify's limit is shared with the service's other emails
  RATE_LIMIT = 3_000
  RATE_LIMIT_BUFFER = 0.5
  TIME_BETWEEN_BATCHES = 60 # seconds

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
      Rails.logger.error "Stopped sending reform comms emails as Notify rejected one for exceeding a limit: " \
                         "#{e.message}. Re-run to send the rest."
      break
    rescue StandardError => e
      Airbrake.notify e, registration: references(registrations)
      Rails.logger.error "Failed to send reform comms email for registrations #{references(registrations)}"
    end

    output_totals(output, sent_count, registration_count)

    sent_count
  end

  private

  def output_totals(output, sent_count, registration_count)
    output.puts "Reform comms emails #{@dry_run ? 'to send' : 'sent'}: #{sent_count}",
                "Registrations covered: #{registration_count}"
  end

  def send_email(email, registrations)
    prefix = @dry_run ? "[DRY RUN] Would send" : "Sending"
    Rails.logger.info "#{prefix} reform comms email for #{references(registrations)}"

    OctoberReformCommsEmailService.run(email:, registrations:) unless @dry_run
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
    active_registrations
      .group_by { |registration| normalise(registration.contact_email) }
      .reject { |email, _registrations| email.blank? || already_sent_to.include?(email) }
  end

  def active_registrations
    WasteExemptionsEngine::Registration
      .where(id: WasteExemptionsEngine::RegistrationExemption.active.not_expired.select(:registration_id))
      .contact_email_present
      .select(:id, :reference, :contact_email)
      .order(:id)
  end

  def already_sent_to
    @already_sent_to ||= WasteExemptionsEngine::CommunicationLog
                         .where(template_id: OctoberReformCommsEmailService::TEMPLATE_ID)
                         .pluck(:sent_to)
                         .to_set { |email| normalise(email) }
  end

  def references(registrations)
    registrations.map(&:reference).join(", ")
  end

  def normalise(email)
    email.to_s.strip.downcase
  end
end
