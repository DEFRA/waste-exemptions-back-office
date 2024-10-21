# frozen_string_literal: true

namespace :companies_house_name_matching do
  desc "Match company names and those from companies house to change names (DRY RUN)"
  task dry_run: :environment do
    CompaniesHouseNameMatchingService.run
  end

  desc "Match company names and those from companies house to change names"
  task run: :environment do
    CompaniesHouseNameMatchingService.run(dry_run: false)
  end
end
