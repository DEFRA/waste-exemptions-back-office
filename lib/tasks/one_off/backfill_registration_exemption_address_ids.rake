# frozen_string_literal: true

namespace :one_off do
  desc "Backfill address_id on registration_exemptions with site_address from registration"
  task backfill_registration_exemption_address_ids: :environment do
    BackfillRegistrationExemptionAddressIds.new.call
  end
end

class BackfillRegistrationExemptionAddressIds
  include WasteExemptionsEngine::ApplicationHelper

  def initialize
    @total_updated = 0
    @errors = {}
    @error_details = {}
  end

  def call
    puts "Starting to backfill address_id on registration_exemptions..."

    registration_exemptions = WasteExemptionsEngine::RegistrationExemption
                              .where(address_id: nil)

    puts "Found #{registration_exemptions.count} registration_exemptions without address_id"

    process_registration_exemptions(registration_exemptions)
    output_final_results
  end

  private

  def process_registration_exemptions(registration_exemptions)
    registration_exemptions.find_each.with_index do |registration_exemption, index|
      process_single_registration_exemption(registration_exemption)
      output_progress(index) if ((index + 1) % 100).zero?
    end
  end

  def process_single_registration_exemption(registration_exemption)
    registration = registration_exemption.registration
    site_address = registration.site_address

    if site_address.present?
      registration_exemption.update!(address_id: site_address.id)
      @total_updated += 1
    else
      puts "WARNING: Registration #{registration.id} has no site_address - skipping."
    end
  rescue StandardError => e
    handle_error(registration_exemption, e)
  end

  def handle_error(registration_exemption, error)
    @errors[registration_exemption.id] = true
    @error_details[registration_exemption.id] = error.message
    puts "ERROR: Failed to update registration_exemption #{registration_exemption.id}: #{error.message}"
  end

  def output_progress(index)
    puts "Processed #{index + 1} registration_exemptions (#{@total_updated} updated)..."
  end

  def output_final_results
    puts "Completed backfilling address_id on registration_exemptions."
    puts "Total registration_exemptions updated: #{@total_updated}"
    puts "Total errors: #{@errors.size}"
    puts "Error details: #{@error_details.inspect}" if @error_details.any?
  end
end
