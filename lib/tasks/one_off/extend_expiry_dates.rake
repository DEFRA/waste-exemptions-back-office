# frozen_string_literal: true

namespace :one_off do
  namespace :extend_expiry_dates do
    # https://eaflood.atlassian.net/browse/RUBY-3671
    desc "Extend expiry dates of active T28 registrations"
    # Usage: rake one_off:extend_expiry_dates:active_t28_registrations[date_from,date_to]
    task :active_t28_registrations, %i[date_from date_to] => :environment do |_t, args|
      # one off rake task to extend any active registration with a T28 exemption
      # which expire between 28th March - 15th September 2025

      date_from = args[:date_from] || "2025-03-28"
      date_to = args[:date_to] || "2025-09-15"

      t28_exemption_id = WasteExemptionsEngine::Exemption.find_by(code: "T28").id

      # 1. find registrations with active T28 exemptions
      registrations = WasteExemptionsEngine::RegistrationExemption.active.where(
        exemption_id: t28_exemption_id, expires_on: date_from..date_to
      ).map(&:registration)

      # 2. extend the expiry date of each registration by 6 months
      registrations.each { |r| extend_registration_expiry_date_by_6months(r) }

      print_registration_stats(registrations)
    end

    # https://eaflood.atlassian.net/browse/RUBY-3672
    desc "Extend expiry dates of active charity registrations"
    # Usage: rake one_off:extend_expiry_dates:active_charity_registrations[date_from,date_to]
    task :active_charity_registrations, %i[date_from date_to] => :environment do |_t, args|
      # one off rake task to extend any active charity registration
      # expiring between 28th March - 15th September 2025

      date_from = args[:date_from] || "2025-03-28"
      date_to = args[:date_to] || "2025-09-15"

      # 1. find active charity registrations
      registrations = WasteExemptionsEngine::Registration.where(business_type: "charity").select do |r|
        r.active_exemptions.any? && r.expires_on.between?(Date.parse(date_from), Date.parse(date_to))
      end

      # 2. extend the expiry date of each registration by 6 months
      registrations.each { |r| extend_registration_expiry_date_by_6months(r) }

      print_registration_stats(registrations)
    end
  end
end

# :nocov:
def print_registration_stats(registrations)
  return if Rails.env.test?

  # 3. Output the number of registrations updated
  puts "Updated #{registrations.count} registration(s)"

  # 4. Output the registration numbers and new expiry dates of the registrations updated
  return unless registrations.any?

  puts "RegNumber | ExpiryDate"
  registrations.each do |registration|
    reg_expiry_date_formatted = registration.registration_exemptions.first.expires_on.to_fs(:day_month_year)
    puts "#{registration.reference} | #{reg_expiry_date_formatted}"
  end
end
# :nocov:

def extend_registration_expiry_date_by_6months(registration)
  registration.registration_exemptions.select(&:active?).each do |re|
    re.update(expires_on: re.expires_on + 6.months)
  end
end
