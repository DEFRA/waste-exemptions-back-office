# frozen_string_literal: true

require "benchmark"

desc "benchmark search operation"
task :benchmark_search, %i[term filter page] => :environment do |_t, args|
  term = args[:term] || ""
  model = args[:filter]
  page = args[:page]
  puts "Searching with term: \"#{term}\", model: \"#{model}\", page: #{page}\n" unless Rails.env.test?

  res = nil
  Benchmark.bmbm do |x|
    x.report("search benchmark") do
      res = SearchService.new.search(term, model, page)
    end
  end
end
