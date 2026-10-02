# frozen_string_literal: true

class FixSvZeroGridReferencesService < WasteExemptionsEngine::BaseService
  BAD_GRID_REFERENCE = "SV0000000000"

  def run(dry_run: true)
    @dry_run = dry_run

    addresses.find_each { |address| fix(address) }
  end

  private

  attr_reader :dry_run

  def addresses
    WasteExemptionsEngine::Address.site.where(
      "REGEXP_REPLACE(UPPER(grid_reference), '[[:space:]]+', '', 'g') = ?",
      BAD_GRID_REFERENCE
    )
  end

  def fix(address)
    attributes = corrected_attributes(address)
    return log_unfixed(address) unless attributes
    return log_update(address, attributes, "[DRY RUN] Would update") if dry_run

    update_address(address, attributes)
    log_update(address, attributes, "Updated")
  rescue StandardError => e
    Airbrake.notify(e, address_id: address.id, registration_id: address.registration_id) if defined?(Airbrake)
    log_error(address, e)
  end

  def corrected_attributes(address)
    matched_address = find_address(address)
    return unless matched_address

    easting, northing = coordinates(matched_address)
    return unless easting && northing

    corrected_address = address.dup
    corrected_address.assign_attributes(x: easting, y: northing, grid_reference: nil, area: nil)
    WasteExemptionsEngine::AssignSiteDetailsService.run(address: corrected_address)
    return if corrected_address.grid_reference.blank? || corrected_address.area.blank?

    {
      x: corrected_address.x,
      y: corrected_address.y,
      grid_reference: corrected_address.grid_reference,
      area: corrected_address.area
    }
  end

  def coordinates(address)
    easting = Float(address["x"], exception: false)
    northing = Float(address["y"], exception: false)

    [easting, northing] if [easting, northing].all? { |coordinate| coordinate&.finite? && coordinate.positive? }
  end

  def find_address(address)
    return if address.postcode.blank? || address.uprn.blank?

    response = WasteExemptionsEngine::AddressLookupService.run(address.postcode)
    return unless response.successful?

    matches = response.results.select { |result| result["uprn"].to_s == address.uprn.to_s }
    matches.first if matches.one?
  end

  def update_address(address, attributes)
    ActiveRecord::Base.transaction do
      address.lock!
      address.update!(attributes)
      RecordSiteLocationFixHistoryService.run(registration: address.registration)
    end
  end

  # :nocov:
  # rubocop:disable Rails/Output
  def log_update(address, attributes, action)
    log(
      "#{action} #{address_details(address)} " \
      "grid_reference=#{attributes[:grid_reference].inspect} area=#{attributes[:area].inspect}"
    )
  end

  def log_unfixed(address)
    log(
      "Unable to fix #{address_details(address)} " \
      "mode=#{address.mode} postcode_present=#{address.postcode.present?} uprn_present=#{address.uprn.present?}"
    )
  end

  def log_error(address, error)
    log("Error fixing #{address_details(address)}: #{error.message}")
  end

  def log(message)
    puts(message) unless Rails.env.test?
  end
  # rubocop:enable Rails/Output
  # :nocov:

  def address_details(address)
    "address #{address.id} (registration #{address.registration&.reference})"
  end
end
