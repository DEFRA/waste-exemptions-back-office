# frozen_string_literal: true

class OrderPresenter < BasePresenter
  def exemption_codes
    exemptions.map(&:code).sort.join(", ")
  end

  def exemption_codes_excluding_bucket
    bucket_exemptions = bucket.present? ? bucket.exemptions : []
    (exemptions - bucket_exemptions).map(&:code).sort.join(", ")
  end

  def bucket_exemption_codes
    return if bucket.blank?

    (exemptions & bucket.exemptions).map(&:code).sort.join(", ")
  end
end
