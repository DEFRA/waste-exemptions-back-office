# frozen_string_literal: true

# Gives the reform comms communication logs that Notify's delivery receipt missed the status their
# notification ended in. One receipt covers every log sharing its notification id, so where some of
# those logs hold a terminal status the rest belong in it too.
class BackfillReformCommsLogStatusesService < WasteExemptionsEngine::BaseService
  TEMPLATE_ID = OctoberReformCommsEmailService::TEMPLATE_ID
  TERMINAL_STATUSES = WasteExemptionsEngine::NotifyCallbackHandlerService::TERMINAL_STATUSES

  def run(dry_run: false, output: $stdout)
    @dry_run = dry_run
    @output = output
    @log_count = 0

    counts_by_notification.each do |(notification_id, sent_to), counts_by_status|
      backfill(notification_id, sent_to, counts_by_status)
    end

    @output.puts "Communication logs #{@dry_run ? 'to update' : 'updated'}: #{@log_count}"

    @log_count
  end

  private

  def backfill(notification_id, sent_to, counts_by_status)
    stale_statuses = counts_by_status.keys - TERMINAL_STATUSES
    status = (counts_by_status.keys & TERMINAL_STATUSES).first

    return if stale_statuses.empty? || status.nil?

    count = counts_by_status.values_at(*stale_statuses).sum
    @output.puts "#{sent_to}: #{count} -> #{status}"
    @log_count += count

    return if @dry_run

    # rubocop:disable-next Rails/SkipsModelValidations
    reform_comms_logs.where(notification_id:, status: stale_statuses)
                     .update_all(status:, updated_at: Time.zone.now)
  end

  # The statuses each notification's logs hold, as { [notification_id, sent_to] => { status => count } }
  def counts_by_notification
    reform_comms_logs
      .group(:notification_id, :sent_to, :status)
      .order(:status)
      .count
      .each_with_object({}) do |((notification_id, sent_to, status), count), counts|
        counts[[notification_id, sent_to]] ||= {}
        counts[[notification_id, sent_to]][status] = count
      end
  end

  # Logs without a notification id were never accepted by Notify, and grouping them would mix up
  # unrelated messages
  def reform_comms_logs
    WasteExemptionsEngine::CommunicationLog
      .where(template_id: TEMPLATE_ID)
      .where.not(notification_id: nil)
  end
end
