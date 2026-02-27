# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class FarmComplianceChargeRowPresenter < BaseRegistrationRowPresenter
      def charge_type
        "compliance_farm"
      end

      def charge_amount
        display_pence_as_pounds_and_pence(pence: @secondary_object.bucket_charge_amount,
                                          hide_pence_if_zero: true)
      end

      def summary_charge_amount_in_pence
        @secondary_object.bucket_charge_amount
      end

      def exemption
        order = @secondary_object.order
        order_bucket = order.bucket

        unless order.present? && order_bucket.present?
          message = "Invalid farm compliance charge row for registration #{registration_no}: " \
                    "order present: #{order.present?}, order bucket present: #{order_bucket.present?}"
          Rails.logger.warn message
          Airbrake.notify message

          return
        end

        order_bucket_exemptions = order.exemptions & order_bucket.exemptions
        order_bucket_exemptions.map(&:code).sort.join(", ")
      end

      def balance
        @total -= @secondary_object.bucket_charge_amount
        display_pence_as_pounds_and_pence(pence: @total,
                                          hide_pence_if_zero: true)
      end
    end
  end
end
