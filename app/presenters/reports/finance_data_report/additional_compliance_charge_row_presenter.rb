# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class AdditionalComplianceChargeRowPresenter < BaseRegistrationRowPresenter
      def charge_type
        "compliance_additional"
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: @secondary_object.additional_compliance_charge_amount,
                                          hide_pence_if_zero: true)
      end

      def charge_band
        @secondary_object.band.sequence
      end
    end
  end
end
