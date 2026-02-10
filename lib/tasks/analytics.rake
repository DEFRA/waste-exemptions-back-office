# frozen_string_literal: true

namespace :analytics do
  desc "Cross-check analytics dashboard stats against direct registration queries"
  task :cross_check, %i[start_date end_date] => :environment do |_t, args|
    unless args[:start_date].present? && args[:end_date].present?
      puts "Usage: rake analytics:cross_check[YYYY-MM-DD,YYYY-MM-DD]"
      puts "Example: rake analytics:cross_check[2025-08-01,2025-12-31]"
      exit
    end

    start_date = Date.parse(args[:start_date])
    end_date = Date.parse(args[:end_date])

    counts = Analytics::CrossCheckService.run(start_date:, end_date:)

    print_header(start_date, end_date)
    print_comparison_row("Total completed:", counts[:reg_total], counts[:analytics_total])
    print_comparison_row("  Front office:", counts[:reg_fo], counts[:analytics_fo])
    print_comparison_row("  Back office:", counts[:reg_bo], counts[:analytics_bo])
    puts ""
  end
end

def print_header(start_date, end_date)
  divider = "  #{'-' * 71}"

  puts ""
  puts "  SIDE-BY-SIDE COMPARISON (excluding edit journeys and Wales/Scotland/NI redirects)"
  puts "  Regs: submitted_at in range | Analytics: completed_at in range"
  puts "  Date range: #{start_date} to #{end_date}"
  puts divider
  puts "  #{'Metric'.ljust(35)} #{'Registrations'.rjust(10)} #{'Analytics'.rjust(10)} #{'Delta'.rjust(10)}"
  puts divider
end

def print_comparison_row(label, reg_val, analytics_val)
  delta = analytics_val - reg_val
  delta_str = delta.zero? ? "0" : format("%+d", delta)
  puts format(
    "  %<label>-38s %<reg>10d %<analytics>10d %<delta>10s",
    label: label, reg: reg_val, analytics: analytics_val, delta: delta_str
  )
end
