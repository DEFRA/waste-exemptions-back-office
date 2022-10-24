# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :summary_stats do
  desc "Generate simple summary stats for use in quarterly DEFRA reports"

  task :stats_for_date_range, %i[start_date end_date] => :environment do |_t, args|

    include ActionView::Helpers::NumberHelper

    unless args[:start_date].present? && args[:end_date].present?
      puts "Usage, with date format YYYY-MM-DD: rake summary_stats[start_date,end_date]"
      exit
    end

    start_date = Date.parse(args[:start_date])
    end_date = Date.parse(args[:end_date]) + 1.day # the aggregations compare with start of day, not end of day

    puts "===================================================================================================="

    abandon_rate = calcs_for_abandon_rate
    calcs_for_date_range(start_date, end_date, abandon_rate)
  end

  def calcs_for_abandon_rate
    # we only have transient_registration data for the last 30 days. Use these to estimate the abandon rate.

    puts "Calculations:"

    transient_30d = WasteExemptionsEngine::TransientRegistration.count
    puts "\tTransient registrations created in the last 30 days: #{transient_30d}"

    activated_30d = WasteExemptionsEngine::Registration.where("created_at > ?", 30.days.ago).count
    puts "\tRegistrations activated in the last 30 days: #{activated_30d}"

    started_30d = transient_30d + activated_30d
    puts "\tSo total registrations started in the last 30 days ~ #{transient_30d} + #{activated_30d} = #{started_30d}"

    abandoned_30d = transient_30d.to_f / started_30d
    puts "\tSo approximate abandon rate = #{transient_30d} / #{started_30d} " \
         "= #{number_to_percentage(100.0 * abandoned_30d, precision: 0)}"

    abandoned_30d
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def calcs_for_date_range(start_date, end_date, abandon_rate)
    puts "\tFrom #{start_date} to #{end_date} inclusive:"

    total_registrations = WasteExemptionsEngine::Registration.where(
      created_at: start_date.beginning_of_day..end_date.end_of_day
    ).count
    total_registrations_s = number_with_delimiter(total_registrations)
    puts "\tTotal registrations: #{total_registrations}, of which:"

    assisted_digital_registrations = WasteExemptionsEngine::Registration.where(
      created_at: start_date.beginning_of_day..end_date.end_of_day,
      assistance_mode: "full"
    ).count
    assisted_digital_registrations_s = number_with_delimiter(assisted_digital_registrations)
    puts "\t... assisted digital: #{assisted_digital_registrations_s}"

    fully_digital_registrations = WasteExemptionsEngine::Registration.where(
      created_at: start_date.beginning_of_day..end_date.end_of_day,
      assistance_mode: nil
    ).count
    fully_digital_registrations_s = number_with_delimiter(fully_digital_registrations)
    puts "\t... fully digital: #{fully_digital_registrations}"

    delta = total_registrations - assisted_digital_registrations - fully_digital_registrations
    puts "\t(delta of #{delta} is due to some registrations not having metaData.route set)" unless delta.zero?

    abandon_rate_s = number_to_percentage(100.0 * abandon_rate, precision: 0)
    non_abandon_rate_s = number_to_percentage(100.0 * (1 - abandon_rate), precision: 0)

    total_registrations_started = (total_registrations / (1.0 - abandon_rate)).round(0)
    total_registrations_started_s = number_with_delimiter(total_registrations_started.to_i)

    total_registrations_completed = fully_digital_registrations + assisted_digital_registrations + delta
    total_registrations_completed_s = number_with_delimiter(total_registrations_completed)

    total_registrations_started_online = (fully_digital_registrations / (1.0 - abandon_rate)).round(0)
    total_registrations_started_online_s = number_with_delimiter(total_registrations_started_online)

    total_registrations_abandoned = total_registrations_started - total_registrations_completed
    total_registrations_abandoned_s = number_with_delimiter(total_registrations_abandoned)

    puts "\tSo including abandoned attempts, estimated orders started = " \
         "#{total_registrations_s} / (1 - #{abandon_rate_s}) = #{total_registrations_started_s}, of which: "
    puts "\t... completed: #{total_registrations_completed_s}"
    puts "\t... abandoned: #{total_registrations_abandoned_s}"

    puts "\nSummary:"
    puts "\t1. Total number of transactions started and completed online only: #{fully_digital_registrations_s}"
    puts "\t2. Total number of transactions started online: ESTIMATED: #{total_registrations_started_online_s}"
    puts "\t\t(Estimated dropoff rate for the last 30 days: #{abandon_rate_s}"
    puts "\t\t so estimated completion (non-abandoned) rate for the last 30 days: #{non_abandon_rate_s}"
    puts "\t\t so given #{fully_digital_registrations_s} fully digital orders, " \
         "estimated total orders started online = " \
         "(#{fully_digital_registrations_s}/#{non_abandon_rate_s}) = #{total_registrations_started_online_s})"
    puts "\t3. Number of online claims: #{fully_digital_registrations_s}"
    puts "\t4. Total number of claims (online + offline + unknown): " \
         "#{fully_digital_registrations_s} + #{assisted_digital_registrations_s} + " \
         "#{delta} = #{total_registrations_completed_s}"

    puts "===================================================================================================="
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/BlockLength
