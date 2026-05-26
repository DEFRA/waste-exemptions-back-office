# frozen_string_literal: true

require "csv"

module Reports
  module SsclReceiptsReport
    class DataSerializer
      CHARGING_STARTED_ON = Date.new(2025, 2, 1)

      COLUMNS = {
        registration_reference: "WEX Reg number",
        registration_date: "Date of reg",
        payment_date: "Date of payment",
        payment_added_date: "Date payment added to registration",
        payment_type: "Payment type"
      }.freeze

      def initialize(date_from: CHARGING_STARTED_ON, date_to: Time.zone.today)
        @date_from = date_from.to_date
        @date_to = date_to.to_date
      end

      def to_csv
        CSV.generate do |csv|
          csv << COLUMNS.values

          payments_scope.find_each(batch_size: batch_size) do |payment|
            csv << present_row(payment)
          end
        end
      end

      private

      def payments_scope
        WasteExemptionsEngine::Payment
          .success
          .excluding_refunds_and_reversals
          .joins(account: :registration)
          .includes(account: :registration)
          .where(date_time: @date_from.beginning_of_day..@date_to.end_of_day)
      end

      def present_row(payment)
        registration = payment.account.registration

        [
          registration.reference,
          formatted_date(registration.submitted_at),
          formatted_date(payment.date_time),
          formatted_date(payment.created_at),
          PaymentPresenter.new(payment).payment_type
        ]
      end

      def formatted_date(date_or_time)
        date_or_time&.to_date&.to_fs(:day_month_year_slashes)
      end

      def batch_size
        WasteExemptionsBackOffice::Application.config.export_batch_size.to_i
      end
    end
  end
end
