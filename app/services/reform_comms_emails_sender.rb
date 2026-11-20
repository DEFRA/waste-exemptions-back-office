# frozen_string_literal: true

require "notifications/client"

# Sends a reform comms email once to each unique contact email address across the registrations a
# subclass selects, in batches that stay within Notify's rate limit. A dry run lists each email and
# its registrations on the output, and every run ends with the totals.
class ReformCommsEmailsSender < WasteExemptionsEngine::BaseService
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
      Rails.logger.error "Stopped sending #{description}s as Notify rejected one for exceeding a limit: " \
                         "#{e.message}. Re-run to send the rest."
      break
    rescue StandardError => e
      Airbrake.notify e, registration: references(registrations)
      Rails.logger.error "Failed to send #{description} for registrations #{references(registrations)}"
    end

    output_totals(output, sent_count, registration_count)

    sent_count
  end

  private

  # Registrations the email could go to, before they are grouped by address
  def candidate_registrations
    raise NotImplementedError
  end

  # Normalised addresses to leave out, usually because they already have the email
  def addresses_to_skip
    raise NotImplementedError
  end

  def email_service
    raise NotImplementedError
  end

  # Names the email in the logs and output, e.g. "reform comms email"
  def description
    raise NotImplementedError
  end

  def registrations_by_email
    candidate_registrations
      .group_by { |registration| normalise(registration.contact_email) }
      .reject { |email, _registrations| email.blank? || addresses_to_skip.include?(email) }
  end

  def output_totals(output, sent_count, registration_count)
    output.puts "#{description.upcase_first}s #{@dry_run ? 'to send' : 'sent'}: #{sent_count}",
                "Registrations covered: #{registration_count}"
  end

  def send_email(email, registrations)
    prefix = @dry_run ? "[DRY RUN] Would send" : "Sending"
    Rails.logger.info "#{prefix} #{description} for #{references(registrations)}"

    email_service.run(email:, registrations:) unless @dry_run
  end

  # Read off the subclass so a spec can stub the limit down to a testable size
  def batch_size
    (self.class::RATE_LIMIT * self.class::RATE_LIMIT_BUFFER).to_i
  end

  # Waits until a minute has passed since the previous batch started
  def wait_for_next_batch
    return if @dry_run

    now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    sleep(@next_batch_at - now) if @next_batch_at && @next_batch_at > now
    @next_batch_at = Process.clock_gettime(Process::CLOCK_MONOTONIC) + TIME_BETWEEN_BATCHES
  end

  def references(registrations)
    registrations.map(&:reference).join(", ")
  end

  def normalise(email)
    email.to_s.strip.downcase
  end
end
