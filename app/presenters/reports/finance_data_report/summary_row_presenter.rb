# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class SummaryRowPresenter < BaseRegistrationRowPresenter
      def charge_type
        "summary"
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: summary_charge_total_in_pence, hide_pence_if_zero: true)
      end

      def balance
        display_pence_as_pounds_and_pence(pence: @total, hide_pence_if_zero: true)
      end

      private

      def summary_charge_total_in_pence
        @secondary_object.to_i
      end
    end
  end
end
