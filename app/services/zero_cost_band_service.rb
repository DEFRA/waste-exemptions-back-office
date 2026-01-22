# frozen_string_literal: true

class ZeroCostBandService < WasteExemptionsEngine::BaseService
  BAND_NAME = "Zero compliance cost band"
  BAND_SEQUENCE = 0

  def initialize
    @logger = Logger.new($stdout)
    super
  end

  def run
    band = create_zero_cost_band
    log_band_details(band)
    band
  end

  def assign_exemption(exemption_code)
    log_message "Assigning #{exemption_code} exemption to zero compliance cost band..."

    band = WasteExemptionsEngine::Band.find_by(sequence: BAND_SEQUENCE)
    return log_error("Zero compliance cost band (sequence 0) not found.") if band.nil?

    exemption = WasteExemptionsEngine::Exemption.find_by(code: exemption_code)
    return log_error("#{exemption_code} exemption not found.") if exemption.nil?

    previous_band = exemption.band
    exemption.update!(band: band)

    log_message "#{exemption_code} exemption assigned to zero compliance cost band."
    log_message "  Previous band: #{previous_band&.name || 'None'}"
    log_message "  New band: #{band.name}"
    true
  end

  private

  def create_zero_cost_band
    log_message "Creating zero compliance cost band..."

    band = WasteExemptionsEngine::Band.find_or_initialize_by(sequence: BAND_SEQUENCE)
    band.name = BAND_NAME

    if band.new_record?
      band.save!
      create_zero_charges_for_band(band)
      log_message "Zero compliance cost band created successfully."
    elsif band.changed?
      band.save!
      log_message "Zero compliance cost band name updated."
    else
      log_message "Zero compliance cost band already exists."
    end

    band.reload
  end

  def create_zero_charges_for_band(band)
    WasteExemptionsEngine::Charge.create!(
      charge_type: :initial_compliance_charge,
      name: "initial compliance charge for #{BAND_NAME}",
      charge_amount: 0,
      chargeable: band
    )

    WasteExemptionsEngine::Charge.create!(
      charge_type: :additional_compliance_charge,
      name: "additional compliance charge for #{BAND_NAME}",
      charge_amount: 0,
      chargeable: band
    )
  end

  def log_band_details(band)
    log_message "Band details:"
    log_message "  Name: #{band.name}"
    log_message "  Sequence: #{band.sequence}"
    log_message "  Initial compliance charge: £#{format('%.2f', band.initial_compliance_charge.charge_amount / 100.0)}"
    log_message "  Additional compliance charge: £#{format('%.2f',
                                                           band.additional_compliance_charge.charge_amount / 100.0)}"
  end

  def log_message(message)
    @logger.info message
  end

  def log_error(message)
    @logger.error message
    false
  end
end
