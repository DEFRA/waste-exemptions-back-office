# frozen_string_literal: true

desc "Load administrative boundary definitions"
task load_admin_areas: :environment do
  EaPublicFaceAreaDataLoadService.run
rescue StandardError => e
  puts "Error loading Administrative areas: #{e}\n#{e.backtrace}"
end
