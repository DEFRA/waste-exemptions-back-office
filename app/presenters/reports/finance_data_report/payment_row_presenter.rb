# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class PaymentRowPresenter < BaseRegistrationRowPresenter
      def payment_type
        if @secondary_object.payment_type == WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY
          @registration.assistance_mode == "full" ? "card(moto)" : "card"
        else
          @secondary_object.payment_type
        end
      end

      def reference
        @secondary_object.reference
      end

      def payment_amount
        display_pence_as_pounds_and_pence(pence: record_amount, hide_pence_if_zero: true)
      end

      def balance
        @total += record_amount
        display_pence_as_pounds_and_pence(pence: @total, hide_pence_if_zero: true)
      end

      private

      def record_amount
        if [WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND,
            WasteExemptionsEngine::Payment::PAYMENT_TYPE_REVERSAL].include?(@secondary_object.payment_type)
          -@secondary_object.payment_amount
        else
          @secondary_object.payment_amount
        end
      end
    end
  end
end
