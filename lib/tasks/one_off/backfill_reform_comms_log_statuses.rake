# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-4580
  # rake one_off:backfill_reform_comms_log_statuses[live-run] to update the statuses,
  # otherwise runs in dry-run mode by default
  desc "Give the reform comms communication logs Notify's delivery receipt missed their notification's status"
  task :backfill_reform_comms_log_statuses, [:mode] => [:environment] do |_task, args|
    dry_run = args[:mode] != "live-run"

    puts "[DRY RUN] No statuses will be changed" if dry_run && !Rails.env.test?

    BackfillReformCommsLogStatusesService.run(dry_run: dry_run)
  end
end
