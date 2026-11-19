# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-4580
  # rake one_off:send_follow_up_reform_comms_emails[live-run] to send the emails,
  # otherwise runs in dry-run mode by default
  desc "Send the reform comms email again, once to each unique contact email it was not delivered to"
  task :send_follow_up_reform_comms_emails, [:mode] => [:environment] do |_task, args|
    dry_run = args[:mode] != "live-run"

    puts "[DRY RUN] No emails will be sent" if dry_run && !Rails.env.test?

    SendFollowUpReformCommsEmailsService.run(dry_run: dry_run)
  end
end
