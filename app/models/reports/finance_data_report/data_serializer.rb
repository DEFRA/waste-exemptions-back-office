# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class DataSerializer
      ATTRIBUTES = %i[
        registration_no
        date
        charge_type
        charge_amount
        charge_band
        exemption
        payment_type
        refund_type
        reference
        comments
        payment_amount
        on_a_farm
        is_a_farmer
        ea_admin_area
        balance
      ].freeze

      def to_csv
        CSV.generate do |csv|
          csv << self.class::ATTRIBUTES

          registrations_scope.find_in_batches(batch_size: batch_size) do |batch|
            batch.each do |registration|
              # support multiple orders per registration
              registration.account.orders.each do |order|
                order_rows = generate_order_rows(registration, order)
                order_rows.each { |r| csv << r }
              end
            end
          end
        end
      end

      private

      def generate_order_rows(registration, order)
        return [] if order&.charge_detail.blank?

        order_rows = []
        # registration charge row
        charge_detail = order.charge_detail
        order_rows << registration_charge_row(registration, charge_detail)

        order.charge_detail.band_charge_details.each do |band_charge_detail|
          # initial compliance charge row
          order_rows << initial_compliance_charge_row(registration, band_charge_detail)
          # additional compliance charge row
          order_rows << additional_compliance_charge_row(registration, band_charge_detail)
        end

        registration.account.charge_adjustments.each do |charge_adjustment|
          # charge adjustment row
          order_rows << charge_adjustment_row(registration, charge_adjustment)
        end

        registration.account.payments.each do |payment|
          # payment row
          order_rows << payment_row(registration, payment)
        end
        order_rows
      end

      def initial_compliance_charge_row(registration, secondary_object)
        presenter = FinanceDataReport::InitialComplianceChargeRowPresenter.new(registration:, secondary_object:)
        ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
      end

      def additional_compliance_charge_row(registration, secondary_object)
        presenter = FinanceDataReport::AdditionalComplianceChargeRowPresenter.new(registration:, secondary_object:)
        ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
      end

      def registration_charge_row(registration, secondary_object)
        presenter = FinanceDataReport::RegistrationChargeRowPresenter.new(registration:, secondary_object:)
        ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
      end

      def charge_adjustment_row(registration, secondary_object)
        presenter = FinanceDataReport::ChargeAdjustmentRowPresenter.new(registration:, secondary_object:)
        ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
      end

      def payment_row(registration, secondary_object)
        presenter = FinanceDataReport::PaymentRowPresenter.new(registration:, secondary_object:)
        ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
      end

      def registrations_scope
        WasteExemptionsEngine::Registration.all
      end

      def batch_size
        WasteExemptionsBackOffice::Application.config.export_batch_size.to_i
      end
    end
  end
end
