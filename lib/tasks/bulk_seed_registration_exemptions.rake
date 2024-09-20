# frozen_string_literal: true

require "factory_bot_rails"
require "benchmark"
require "timecop"

desc "Bulk seed registration exemptions for performance test / benchmarking purposes"
task :bulk_seed_registration_exemptions, %i[reg_count reg_ex_count] => :environment do |_t, args|
  registration_count = args[:reg_count].to_i
  puts "Creating #{registration_count} registrations..."

  (1..registration_count).each do |r|
    reg_type = %i[registration renewing_registration].sample

    creation_date = rand(1_000).days.ago
    Timecop.freeze(creation_date) do
      case reg_type
      when :registration
        FactoryBot.create(reg_type, submitted_at: creation_date.to_date)
      else
        FactoryBot.create(reg_type)
      end
    end
    puts "... #{r}" if (r % 1000).zero?
  end
end

desc "benchmark search operation"
task :benchmark_search, %i[term filter page] => :environment do |_t, args|
  term = args[:term] || ""
  model = args[:filter]
  page = args[:page]
  puts "Searching with term: \"#{term}\", model: \"#{model}\", page: #{page}\n"

  res = nil
  Benchmark.bmbm do |x|
    x.report("search benchmark") do
      res = SearchService.new.search(term, model, page)
    end
  end

  puts "Found #{res.length} matches (NB Kaminari pagination => max 20 at a time)"
end
