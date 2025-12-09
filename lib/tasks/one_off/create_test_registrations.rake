# frozen_string_literal: true

namespace :one_off do
  # rake "one_off:create_test_registrations[10000,2028-01-01]"
  desc "Create test registrations using FactoryBot"
  task :create_test_registrations, %i[count expiry_date] => [:environment] do |_task, args|
    raise "This task cannot run in production" if Rails.env.production?

    require "factory_bot_rails"

    count = (args[:count] || 1_000).to_i
    expiry_date = Date.parse(args[:expiry_date] || "2028-01-01")

    puts "Creating #{count} test registrations with expiry date #{expiry_date}..." unless Rails.env.test?

    FactoryBot.reload

    count.times do |i|
      registration_exemptions = create_registration_exemptions(expiry_date, 3)
      registration = FactoryBot.create(:registration, registration_exemptions: registration_exemptions)
      registration.regenerate_and_timestamp_edit_token

      order = FactoryBot.create(:order)
      registration.account.orders << order
      registration_exemptions.each { |re| order.order_exemptions.create!(exemption: re.exemption) }

      calc = WasteExemptionsEngine::OrderCalculator.new(
        order: order,
        strategy_type: WasteExemptionsEngine::RegularChargingStrategy
      )
      calc.charge_detail

      puts "Progress: #{i + 1}/#{count}" if ((i + 1) % 100).zero?
    end

    puts "Complete: #{count} registrations created" unless Rails.env.test?
  end
end

def create_registration_exemptions(expiry_date, count)
  selected_exemptions = WasteExemptionsEngine::Exemption.first(count)
  (0..(count - 1)).map do |n|
    FactoryBot.build(:registration_exemption,
                     expires_on: expiry_date,
                     exemption: selected_exemptions[n] || FactoryBot.create(:exemption))
  end
end
