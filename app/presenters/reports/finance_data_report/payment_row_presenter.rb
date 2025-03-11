# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class PaymentRowPresenter < BaseRegistrationRowPresenter

      delegate :reference, to: :@secondary_object

      def payment_type
        if @secondary_object.payment_type == WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY
          @registration.assistance_mode == "full" ? "card(moto)" : "card"
        else
          @secondary_object.payment_type
        end
      end

      def payment_amount
        display_pence_as_pounds_and_pence(pence: amount_to_credit, hide_pence_if_zero: true)
      end

      def balance
        @total += amount_to_credit
        display_pence_as_pounds_and_pence(pence: @total, hide_pence_if_zero: true)
      end

      private

      def amount_to_credit
        @secondary_object.payment_amount
      end
    end
  end
end
