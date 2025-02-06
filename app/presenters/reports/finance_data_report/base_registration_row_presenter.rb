# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class BaseRegistrationRowPresenter
      include FinanceDetailsHelper

      def initialize(registration:, secondary_object: nil)
        @registration = registration
        @secondary_object = secondary_object
      end

      def registration_number
        @registration.reference
      end

      def date
        @registration.submitted_at.to_fs(:day_month_year_slashes)
      end

      def charge_type
        nil
      end

      def charge_amount
        nil
      end

      def charge_band
        nil
      end
    end
  end
end
