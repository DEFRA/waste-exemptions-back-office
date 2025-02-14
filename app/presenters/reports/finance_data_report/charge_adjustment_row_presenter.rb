# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class ChargeAdjustmentRowPresenter < BaseRegistrationRowPresenter
      def charge_type
        "charge_adjust"
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: @secondary_object.amount, hide_pence_if_zero: true)
      end
    end
  end
end
