# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class ChargeAdjustmentRowPresenter < BaseRegistrationRowPresenter
      def charge_type
        "charge_adjust"
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: charge_adjustment_amount, hide_pence_if_zero: true)
      end

      def balance
        @total -= charge_adjustment_amount
        display_pence_as_pounds_and_pence(pence: @total,
                                          hide_pence_if_zero: true)
      end

      private

      def charge_adjustment_amount
        @secondary_object.adjustment_type == "decrease" ? (0 - @secondary_object.amount) : @secondary_object.amount
      end
    end
  end
end
