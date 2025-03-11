# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class RegistrationChargeRowPresenter < BaseRegistrationRowPresenter
      def charge_type
        "registration"
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: @secondary_object.registration_charge_amount, hide_pence_if_zero: true)
      end

      def balance
        @total -= @secondary_object.registration_charge_amount
        display_pence_as_pounds_and_pence(pence: @total,
                                          hide_pence_if_zero: true)
      end
    end
  end
end
