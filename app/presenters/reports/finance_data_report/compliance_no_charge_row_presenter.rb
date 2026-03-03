# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class ComplianceNoChargeRowPresenter < ComplianceChargeRowPresenter
      def charge_type
        "compliance_no_charge"
      end

      def charge_amount_in_pence
        0
      end
    end
  end
end
