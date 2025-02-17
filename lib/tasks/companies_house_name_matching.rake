# frozen_string_literal: true

namespace :companies_house_name_matching do
  desc "Process a SINGLE batch (DRY RUN), then stop."
  task :dry_run_batch, [:report_path] => :environment do |_, args|
    CompaniesHouseNameMatching::ProcessBatch.run(dry_run: true, report_path: args[:report_path])
  end

  desc "Process a SINGLE batch (REAL RUN), then stop."
  task :run_batch, [:report_path] => :environment do |_, args|
    CompaniesHouseNameMatching::ProcessBatch.run(dry_run: false, report_path: args[:report_path])
  end

  desc "DRY RUN - keep running batch after batch (with a 5-minute pause) until no more left."
  task :dry_run_until_done, [:report_path] => :environment do |_, args|
    CompaniesHouseNameMatching::RunnerService.run_until_done(
      dry_run: true,
      report_path: args[:report_path]
    )
  end

  desc "REAL RUN - keep running batch after batch (with a 5-minute pause) until no more left."
  task :run_until_done, [:report_path] => :environment do |_, args|
    CompaniesHouseNameMatching::RunnerService.run_until_done(
      dry_run: false,
      report_path: args[:report_path]
    )
  end
end
