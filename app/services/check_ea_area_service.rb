# frozen_string_literal: true

class CheckEaAreaService < WasteExemptionsEngine::BaseService
  DEFAULT_BATCH_SIZE = 1000

  class EaAreaLookupError < StandardError; end

  def run(batch_size: DEFAULT_BATCH_SIZE, logger: Rails.logger)
    @batch_size = [batch_size.to_i, 1].max
    @logger = logger
    @result = %i[registrations_checked sites_checked sites_updated site_errors].index_with(0)
    @site_errors = []

    log("Checking EA areas for active registration sites")

    active_registrations.find_each(batch_size: @batch_size) do |registration|
      process_registration(registration)
    end

    log_summary
    log_site_errors
    @result
  end

  private

  attr_reader :logger, :result, :site_errors

  def active_registrations
    WasteExemptionsEngine::Registration
      .joins(:registration_exemptions)
      .merge(WasteExemptionsEngine::RegistrationExemption.active)
      .includes(site_addresses: :registration_exemptions)
      .distinct
  end

  def process_registration(registration)
    result[:registrations_checked] += 1

    registration.site_addresses.each do |site_address|
      next unless active_site?(registration, site_address)

      result[:sites_checked] += 1
      process_site(registration, site_address)
    end
  end

  def active_site?(registration, site_address)
    return registration.active? unless registration.multisite?

    site_address.registration_exemptions.any?(&:active?)
  end

  def process_site(registration, site_address)
    previous_area = site_address.area
    new_area = determine_area(site_address)

    return if previous_area == new_area

    ActiveRecord::Base.transaction do
      site_address.update!(area: new_area)
      RecordEaAreaChangeHistoryService.run(registration:)
    end

    result[:sites_updated] += 1
    log_area_update(registration, site_address, previous_area, new_area)
  rescue StandardError => e
    result[:site_errors] += 1
    site_errors << area_error_message(registration, site_address, e)
  end

  def determine_area(site_address)
    area = WasteExemptionsEngine::DetermineAreaService.run(easting: site_address.x, northing: site_address.y)

    raise EaAreaLookupError, "EA area lookup returned no area" if area.blank?

    area
  end

  def log_area_update(registration, site_address, previous_area, new_area)
    log("EA area updated #{site_details(registration, site_address)} " \
        "previous_area=#{previous_area.inspect} new_area=#{new_area.inspect}")
  end

  def area_error_message(registration, site_address, error)
    "EA area check error #{site_details(registration, site_address)} " \
      "error_class=#{error.class.name} error_message=#{error.message.inspect}"
  end

  def site_details(registration, site_address)
    [
      "registration_id=#{registration.id}",
      "registration_reference=#{registration.reference.inspect}",
      "site_address_id=#{site_address.id}",
      "site_reference=#{site_address.reference.inspect}",
      "site_suffix=#{site_address.site_suffix.inspect}",
      "grid_reference=#{site_address.grid_reference.inspect}"
    ].join(" ")
  end

  def log_summary
    log(
      "EA area check complete registrations_checked=#{result[:registrations_checked]} " \
      "sites_checked=#{result[:sites_checked]} sites_updated=#{result[:sites_updated]} " \
      "site_errors=#{result[:site_errors]}"
    )
  end

  def log_site_errors
    return if site_errors.empty?

    log("EA area check errors:")
    site_errors.each { |site_error| log(site_error, level: :error) }
  end

  def log(message, level: :info)
    logger.public_send(level, message)
  end
end
