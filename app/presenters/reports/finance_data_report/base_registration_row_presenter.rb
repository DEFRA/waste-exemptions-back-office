# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class BaseRegistrationRowPresenter
      attr_accessor :total

      include FinanceDetailsHelper

      def initialize(registration:, secondary_object: nil, total: nil)
        @registration = registration
        @secondary_object = secondary_object
        @total = total
      end

      def registration_no
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

      def exemption
        nil
      end

      def payment_type
        nil
      end

      def refund_type
        nil
      end

      def reference
        nil
      end

      def comments
        nil
      end

      def payment_amount
        nil
      end

      def on_a_farm
        @registration.on_a_farm? ? "Yes" : "No"
      end

      def is_a_farmer
        @registration.is_a_farmer? ? "Yes" : "No"
      end

      def ea_admin_area
        @registration.site_address&.area
      end

      def balance
        nil
      end
    end
  end
end
