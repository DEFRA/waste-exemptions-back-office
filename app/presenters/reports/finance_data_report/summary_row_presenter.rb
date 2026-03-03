# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class SummaryRowPresenter
      include FinanceDetailsHelper

      def initialize(registration:, charge_total_in_pence:, balance_in_pence:)
        @registration = registration
        @charge_total_in_pence = charge_total_in_pence
        @balance_in_pence = balance_in_pence
      end

      def to_row(attributes)
        attributes.map do |attribute|
          next unless respond_to?(attribute)

          public_send(attribute)
        end
      end

      def registration_no
        @registration.reference
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

      def charge_type
        "summary"
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: @charge_total_in_pence, hide_pence_if_zero: true)
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
        display_pence_as_pounds_and_pence(pence: @balance_in_pence, hide_pence_if_zero: true)
      end

      def payment_status
        if @balance_in_pence.negative?
          "Unpaid"
        elsif @balance_in_pence.zero?
          "Paid"
        else
          "Overpaid"
        end
      end

      def status
        @registration.state
      end
    end
  end
end
