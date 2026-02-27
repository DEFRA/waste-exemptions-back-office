# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class BaseRegistrationRowPresenter
      attr_accessor :total

      include FinanceDetailsHelper

      def initialize(registration:, secondary_object: nil, total: nil, site_address: nil, show_payment_status: false)
        @registration = registration
        @secondary_object = secondary_object
        @total = total
        @site_address = site_address
        @show_payment_status = show_payment_status
      end

      def registration_no
        if @site_address&.site_suffix.present?
          "#{@registration.reference}/#{@site_address.site_suffix}"
        else
          @registration.reference
        end
      end

      def date
        @registration.submitted_at.to_fs(:day_month_year_slashes)
      end

      def multisite
        @registration.multisite? ? "TRUE" : "FALSE"
      end

      def organisation_name
        @registration.operator_name
      end

      def site
        @site_address&.site_suffix
      end

      def charge_type
        nil
      end

      def charge_amount
        nil
      end

      def summary_charge_amount_in_pence
        0
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
        @site_address&.area || @registration.site_address&.area
      end

      def balance
        nil
      end

      def payment_status
        return nil unless @show_payment_status
        return nil if @total.nil?

        if @total.negative?
          "Unpaid"
        elsif @total.zero?
          "Paid"
        else
          "Overpaid"
        end
      end

      def status
        if @site_address.present?
          @site_address.site_status
        else
          @registration.state
        end
      end
    end
  end
end
