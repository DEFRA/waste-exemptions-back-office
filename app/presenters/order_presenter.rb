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
    return if charge_breakdown.bucket_exemptions.empty?

    format_exemption_codes(charge_breakdown.bucket_exemptions)
  end

  def site_count
    charge_detail&.site_count || 1
  end

  private

  def format_exemption_codes(exemptions)
    exemptions.map(&:code).sort.join(", ")
  end

  def exemptions_excluding_bucket
    charge_breakdown.non_bucket_exemptions
  end

  def chargeable_exemptions_excluding_bucket
    charge_breakdown.chargeable_exemptions
  end

  def no_charge_exemptions_excluding_bucket
    charge_breakdown.no_charge_exemptions
  end

  def charge_breakdown
    @charge_breakdown ||= WasteExemptionsEngine::OrderChargeBreakdown.new(order: model)
  end
end
