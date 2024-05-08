# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc "Load the custom seed data from db/seeds/"
    task single: :environment do
      filename = Dir[Rails.root.join("db", "seeds", "#{ENV.fetch('SEED', nil)}.rb").to_s][0]
      puts "Seeding #{filename}..."
      load(filename) if File.exist?(filename)
    end
  end
end
