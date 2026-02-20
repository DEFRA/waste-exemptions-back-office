# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class InitialComplianceChargeRowPresenter < ComplianceChargeRowPresenter
      def charge_type
        "compliance_initial"
      end

      def charge_amount_in_pence
        if @registration.multisite?
          @secondary_object.initial_compliance_charge_amount / @secondary_object.charge_detail.site_count
        else
          @secondary_object.initial_compliance_charge_amount
        end
      end
    end
  end
end
