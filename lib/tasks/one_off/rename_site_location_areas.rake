# frozen_string_literal: true

require "csv"

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-2148
  desc "Correct site location area names"
  task :rename_site_location_areas, %i[areas_file] => [:environment] do |_task, args|

    areas_csv_file = Rails.root.join("lib/fixtures/#{args[:areas_file]}")

    CSV.foreach(areas_csv_file, headers: :first_row) do |row|
      old_area_name = row["old_area_name"].strip
      new_area_name = row["new_area_name"].strip
      addresses = WasteExemptionsEngine::Address.where(address_type: 3, area: old_area_name)

      unless Rails.env.test?
        puts "Processing #{addresses.count} site locations: \"#{old_area_name}\" => \"#{new_area_name}\""
      end

      addresses.update(area: new_area_name)
    end
  end
end
