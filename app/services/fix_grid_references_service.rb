# frozen_string_literal: true

class FixGridReferencesService < ::WasteExemptionsEngine::BaseService
  def run
    return unless addresses.any?

    log("Fixing Grid References\n======================")
    addresses.find_each do |address|
      from = address.grid_reference
      grid_reference = find_grid_reference(address)
      if grid_reference
        address.update!(grid_reference: grid_reference)
        log_ngr_update(address, from, grid_reference)
      end
    end
  end

  private

  def addresses
    @addresses ||=
      WasteExemptionsEngine::Address
      .where(y: 1..99_999)
      .where.not(mode: :auto)
  end

  def find_grid_reference(address)
    ::WasteExemptionsEngine::DetermineGridReferenceService
      .run(easting: address.x, northing: address.y)
      .presence
  end

  def log_ngr_update(address, from, to)
    log("address #{address.id} changed from: #{from} to: #{to}")
  end

  # :nocov:
  def log(message)
    return if Rails.env.test?

    puts(message)
  end
  # :nocov:
end
