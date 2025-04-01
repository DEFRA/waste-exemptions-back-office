# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class PaymentRowPresenter < BaseRegistrationRowPresenter

      delegate :reference, to: :@secondary_object

      def payment_type
        formatted_payment_type(@secondary_object.payment_type, @registration.assistance_mode)
      end

      def payment_amount
        display_pence_as_pounds_and_pence(pence: amount_to_credit, hide_pence_if_zero: true)
      end

      def balance
        @total += amount_to_credit
        display_pence_as_pounds_and_pence(pence: @total, hide_pence_if_zero: true)
      end

      def refund_type
        return unless @secondary_object.payment_type == WasteExemptionsEngine::Payment::PAYMENT_TYPE_REFUND
        return if @secondary_object.associated_payment_id.nil?

        associated_payment = WasteExemptionsEngine::Payment.find(@secondary_object.associated_payment_id)
        formatted_payment_type(associated_payment.payment_type, @registration.assistance_mode)
      end

      private

      def amount_to_credit
        @secondary_object.payment_amount
      end

      def formatted_payment_type(payment_type, assistance_mode)
        if payment_type == WasteExemptionsEngine::Payment::PAYMENT_TYPE_GOVPAY
          assistance_mode == "full" ? "card(moto)" : "card"
        else
          payment_type
        end
      end
    end
  end
end
