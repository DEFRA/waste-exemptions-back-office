# frozen_string_literal: true

desc "Load administrative boundary definitions"
task load_admin_areas: :environment do
  results = EaPublicFaceAreaDataLoadService.run
  results.each do |result|
    puts "#{result[:action].capitalize} EA Public Face Area \"#{result[:code]}\" (#{result[:name]})"
  end
rescue StandardError => e
  puts "Error loading Administrative areas: #{e}\n#{e.backtrace}"
end
