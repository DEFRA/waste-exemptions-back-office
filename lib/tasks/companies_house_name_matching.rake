# frozen_string_literal: true

namespace :companies_house_name_matching do
  desc "Match company names and those from companies house to change names (DRY RUN)"
  task :dry_run, [:report_path] => :environment do |_, args|
    CompaniesHouseNameMatchingService.run(dry_run: true, report_path: args[:report_path])
  end

  desc "Match company names and those from companies house to change names"
  task :run, [:report_path] => :environment do |_, args|
    CompaniesHouseNameMatchingService.run(dry_run: false, report_path: args[:report_path])
  end
end
