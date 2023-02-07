# frozen_string_literal: true

# This is a minimalist implementation to meet an urgent requirement. It is expected to be enhanced later.
module Reports
  class DefraQuarterlyStatsService < ::WasteExemptionsEngine::BaseService
    attr_reader :start_date, :end_date, :abandon_rate, :abandon_rate_percent

    # rubocop:disable Layout/LineLength
    def run
      report = []
      report << "Abandon rate is not directly tracked. Estimation:"
      activated_last_30_days = WasteExemptionsEngine::Registration.where("created_at > ?", 30.days.ago).count
      report << "  - Registrations activated in the last 30 days: #{activated_last_30_days}"
      transients_last_30_days = WasteExemptionsEngine::TransientRegistration.where("created_at > ?", 30.days.ago).count
      report << "  - Transient registrations remaining (registrations not completed) from the last 30 days: " \
                "#{transients_last_30_days}"
      total_attempts_last_30_days = transients_last_30_days + activated_last_30_days
      report << "  - Total registration attempts for the last 30 days: #{total_attempts_last_30_days}"
      @abandon_rate = total_attempts_last_30_days.zero? ? 0 : transients_last_30_days.to_f / total_attempts_last_30_days
      @abandon_rate_percent = (abandon_rate * 100.0).to_i
      report << "  - Estimated abandon rate: #{@abandon_rate.round(3)} (#{@abandon_rate_percent}%)"
      report << "------------------------------------------------------------------------------------------------------------------"

      4.downto(1).each do |q|
        report.concat(quarter_report(q))
        report << "=================================================================================================================="
      end

      report
    end

    def quarter_report(quarters_ago)
      @start_date, @end_date = quarter_dates(quarters_ago)

      report = []
      report << "Quarterly summary statistics for #{start_date} - #{end_date}"

      # summary statistics
      activated_total = count_activations
      activated_assisted_digital = count_activations("full")
      completed_online = activated_total - activated_assisted_digital

      report << "1. Number of registrations completed online only, EXCLUDING Assisted Digital : " \
                "#{activated_total} - #{activated_assisted_digital} = #{completed_online}"

      report << "2. Number of registrations started and NOT completed: Unknown. Rough estimate based on abandon rate for the last 30 days:"
      report << "  - Given #{completed_online} completed online with an abandon rate of #{@abandon_rate_percent}%:"
      report << "  - ESTIMATED registrations started online and not completed: " \
                "#{estimate_started_online(completed_online, abandon_rate)}"

      report << "3. Same data as 1"

      report << "4. Total number of registrations completed online AND via the Back office: #{completed_online} (of which AD: " \
                "#{activated_assisted_digital})"

      report
    end
    # rubocop:enable Layout/LineLength

    private

    def count_activations(assistance_mode = nil)
      if assistance_mode.blank?
        WasteExemptionsEngine::Registration.where(created_at: start_date.beginning_of_day..end_date.end_of_day).count
          # .where("created_at::time BETWEEN '#{start_date.beginning_of_day}' AND '#{end_date.end_of_day}'").count
      else
        WasteExemptionsEngine::Registration
          .where(created_at: start_date.beginning_of_day..end_date.end_of_day, assistance_mode: assistance_mode).count
          # .where("created_at::time BETWEEN '#{start_date.beginning_of_day}' AND '#{end_date.end_of_day}' and assistance_mode = '#{assistance_mode}'").count
      end
    end

    def estimate_started_online(completed_online, abandon_rate)
      return "N/A" unless completed_online.positive? && abandon_rate < 1.0

      "#{completed_online} / (1 - #{(@abandon_rate * 100.0).to_i}%) = " \
        "#{(completed_online / (1 - @abandon_rate)).round(0)}"
    end

    def quarter_start_month(date)
      day_hash = (date.month * 100) + date.mday
      case day_hash
      when 401..630
        4
      when 631..930
        7
      when 1001..1231
        10
      when 101..331
        1
      end
    end

    # Zero quarters ago is the current quarter
    def quarter_dates(quarters_ago)
      today = Time.zone.today
      current_quarter_start = Date.new(today.year, quarter_start_month(today), 1)
      required_quarter_start = current_quarter_start - (3 * quarters_ago).months
      required_quarter_end = required_quarter_start + 3.months - 1.day

      [required_quarter_start, required_quarter_end]
    end
  end
end
