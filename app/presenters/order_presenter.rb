# frozen_string_literal: true

class OrderPresenter < BasePresenter
  def exemption_codes
    format_exemption_codes(exemptions)
  end

  def exemption_codes_excluding_bucket
    format_exemption_codes(exemptions_excluding_bucket)
  end

  def chargeable_exemption_codes_excluding_bucket
    format_exemption_codes(chargeable_exemptions_excluding_bucket)
  end

  def no_charge_exemption_codes_excluding_bucket
    format_exemption_codes(no_charge_exemptions_excluding_bucket)
  end

  def bucket_exemption_codes
    return if bucket.blank?

    format_exemption_codes(exemptions & bucket.exemptions)
  end

  def site_count
    charge_detail&.site_count || 1
  end

  private

  def format_exemption_codes(exemptions)
    exemptions.map(&:code).sort.join(", ")
  end

  def bucket_exemptions
    bucket.present? ? bucket.exemptions : []
  end

  def exemptions_excluding_bucket
    exemptions - bucket_exemptions
  end

  def chargeable_exemptions_excluding_bucket
    return exemptions_excluding_bucket if no_charge_band_ids.empty?

    exemptions_excluding_bucket.reject { |exemption| no_charge_band_ids.include?(exemption.band_id) }
  end

  def no_charge_exemptions_excluding_bucket
    exemptions_excluding_bucket.select { |exemption| no_charge_band_ids.include?(exemption.band_id) }
  end

  def no_charge_band_ids
    return [] if charge_detail.blank?

    @no_charge_band_ids ||= charge_detail.band_charge_details.filter_map do |band_charge_detail|
      band_charge_detail.band_id if band_charge_detail.total_compliance_charge_amount.zero?
    end
  end
end
