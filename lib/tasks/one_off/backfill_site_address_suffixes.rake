# frozen_string_literal: true

namespace :one_off do
  desc "Backfill site_suffix on site addresses with default value '00001'"
  task backfill_site_address_suffixes: :environment do
    BackfillSiteAddressSuffixes.new.call
  end
end

class BackfillSiteAddressSuffixes
  DEFAULT_SUFFIX = "00001"

  def initialize
    @total_updated = 0
    @errors = {}
    @error_details = {}
  end

  def call
    puts "Starting to backfill site_suffix on site addresses..."

    site_addresses = find_site_addresses_without_suffix
    total_records = calculate_total_records(site_addresses)
    puts "Found #{total_records} site addresses without site_suffix"

    process_site_addresses(site_addresses)
    output_final_results
  end

  private

  def find_site_addresses_without_suffix
    WasteExemptionsEngine::Address.where(address_type: "site", site_suffix: nil)
  end

  def calculate_total_records(site_addresses)
    site_addresses.respond_to?(:count) ? site_addresses.count : site_addresses.size
  end

  def process_site_addresses(site_addresses)
    iterator = site_addresses.respond_to?(:find_each) ? site_addresses.find_each : site_addresses

    iterator.each_with_index do |site_address, index|
      process_single_address(site_address)
      output_progress(index) if ((index + 1) % 100).zero?
    end
  end

  def process_single_address(site_address)
    site_address.update!(site_suffix: DEFAULT_SUFFIX)
    @total_updated += 1
  rescue StandardError => e
    handle_error(site_address, e)
  end

  def handle_error(site_address, error)
    @errors[site_address.id] = true
    @error_details[site_address.id] = error.message
    puts "ERROR: Failed to update site address #{site_address.id}: #{error.message}"
  end

  def output_progress(index)
    puts "Processed #{index + 1} site addresses..."
  end

  def output_final_results
    puts "Completed backfilling site_suffix on site addresses."
    puts "Total site addresses updated: #{@total_updated}"
    puts "Total errors: #{@errors.size}"
    puts "Error details: #{@error_details.inspect}" if @error_details.any?
  end
end
