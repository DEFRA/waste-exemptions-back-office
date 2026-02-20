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

      def exemption
        @secondary_object.charge_detail.order.exemptions.select do |e|
          e.band_id == @secondary_object.band_id && bucket_exemption_codes.exclude?(e.code)
        end.map(&:code).sort.join(", ")
      end

      def balance
        @total -= charge_amount_in_pence
        display_pence_as_pounds_and_pence(pence: @total,
                                          hide_pence_if_zero: true)
      end

      private

      def bucket_exemption_codes
        @secondary_object.charge_detail.order.bucket&.exemptions&.map(&:code) || []
      end
    end
  end
end
