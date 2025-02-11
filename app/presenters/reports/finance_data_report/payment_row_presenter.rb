# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class PaymentRowPresenter < BaseRegistrationRowPresenter
      def payment_type
        @secondary_object.payment_type == "govpay_payment" ? "card" : @secondary_object.payment_type
      end

      def reference
        @secondary_object.reference
      end

      def payment_amount
        display_pence_as_pounds_and_pence(pence: @secondary_object.payment_amount, hide_pence_if_zero: true)
      end

      def balance
        display_pence_as_pounds_and_pence(pence: @secondary_object.account.balance, hide_pence_if_zero: true)
      end
    end
  end
end
