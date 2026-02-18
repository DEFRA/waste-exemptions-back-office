# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class InitialComplianceChargeRowPresenter < BaseRegistrationRowPresenter
      def charge_type
        "compliance_initial"
      end

      def charge_amount
        charge_amount = if @registration.multisite?
                          @secondary_object.initial_compliance_charge_amount /
                            @secondary_object.charge_detail.site_count
                        else
                          @secondary_object.initial_compliance_charge_amount
                        end

        display_pence_as_pounds_and_pence(pence: charge_amount,
                                          hide_pence_if_zero: true)
      end

      def charge_band
        @secondary_object.band.sequence
      end

      def exemption
        @secondary_object.charge_detail.order.exemptions.select do |e|
          e.band_id == @secondary_object.band_id && bucket_exemption_codes.exclude?(e.code)
        end.map(&:code).sort.join(", ")
      end

      def balance
        @total -= @secondary_object.initial_compliance_charge_amount
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
