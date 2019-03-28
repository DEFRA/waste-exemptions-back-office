# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

log_output_path = ENV["EXPORT_SERVICE_CRON_LOG_OUTPUT_PATH"] || "/srv/ruby/waste-exemptions-back-office/shared/log/"
set :output, File.join(log_output_path, "whenever_cron.log")
set :job_template, "/bin/bash -l -c 'eval \"$(rbenv init -)\" && :job'"

# Only one of the AWS app servers has a role of "db"
# see https://gitlab-dev.aws-int.defra.cloud/open/rails-deployment/blob/master/config/deploy.rb#L69
# so only creating cronjobs on that server, otherwise all jobs would be duplicated everyday!

# This is the daily EPR export job. When run this will create a CSV export of
# all records and put this into an AWS S3 bucket from which Epimorphics (the
# company that provides and maintains the EPR) will grab it
every :day, at: (ENV["EXPORT_SERVICE_EPR_EXPORT_TIME"] || "1:05"), roles: [:db] do
  rake "defra_ruby_exporters:epr"
end

# This is the bulk export job. When run this will create batched CSV exports of
# all records and put these files into an AWS S3 bucket.
bulk_frequency = (ENV["EXPORT_SERVICE_BULK_EXPORT_FREQUENCY"] || :sunday).to_sym
bulk_time = (ENV["EXPORT_SERVICE_BULK_EXPORT_TIME"] || "20:05")
every bulk_frequency, at: bulk_time, roles: [:db] do
  rake "defra_ruby_exporters:bulk"
end
