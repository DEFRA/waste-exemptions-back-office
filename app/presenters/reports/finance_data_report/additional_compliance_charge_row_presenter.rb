# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class AdditionalComplianceChargeRowPresenter < ComplianceChargeRowPresenter
      def charge_type
        "compliance_additional"
      end

      def charge_amount_in_pence
        if @registration.multisite?
          @secondary_object.additional_compliance_charge_amount / @secondary_object.charge_detail.site_count
        else
          @secondary_object.additional_compliance_charge_amount
        end
      end
    end
  end
end
