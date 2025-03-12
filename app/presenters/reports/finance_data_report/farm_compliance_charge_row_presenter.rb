# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class FarmComplianceChargeRowPresenter < BaseRegistrationRowPresenter
      def charge_type
        "compliance_farm"
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: @secondary_object.bucket_charge_amount,
                                          hide_pence_if_zero: true)
      end

      def exemption
        order_bucket_exemptions = @secondary_object.order.exemptions & @secondary_object.order.bucket.exemptions
        order_bucket_exemptions.map(&:code).sort.join(", ")
      end

      def balance
        @total -= @secondary_object.bucket_charge_amount
        display_pence_as_pounds_and_pence(pence: @total,
                                          hide_pence_if_zero: true)
      end
    end
  end
end
