namespace :company do
  desc "Identify similar company entries"
  task identify_similars: :environment do
    IdentifySimilarCompanies.run
  end
end
