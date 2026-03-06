# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class ComplianceChargeRowPresenter < BaseRegistrationRowPresenter
      def charge_band
        @secondary_object.band.sequence
      end

      def charge_amount_in_pence
        raise NotImplementedError
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: charge_amount_in_pence,
                                          hide_pence_if_zero: true)
      end

      def summary_charge_amount_in_pence
        charge_amount_in_pence
      end

      def has_non_bucket_exemptions?
        non_bucket_band_exemptions.any?
      end

      def exemption
        non_bucket_band_exemptions.map(&:code).sort.join(", ")
      end

      def balance
        @total -= charge_amount_in_pence
        display_pence_as_pounds_and_pence(pence: @total,
                                          hide_pence_if_zero: true)
      end

      private

      def non_bucket_band_exemptions
        @secondary_object.charge_detail.order.exemptions.select do |exemption|
          exemption.band_id == @secondary_object.band_id && bucket_exemptions.exclude?(exemption)
        end
      end

      def bucket_exemptions
        @secondary_object.charge_detail.order.bucket&.exemptions || []
      end
    end
  end
end
