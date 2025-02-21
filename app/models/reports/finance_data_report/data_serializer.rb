# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class DataSerializer
      attr_accessor :total

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
              next if registration&.account.blank? || registration.account.orders.count.zero?

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
        @total = 0

        # registration charge row
        charge_detail = order.charge_detail
        order_rows.concat(registration_charge_row(registration, charge_detail).compact)
        # compliance charge rows
        charge_detail.band_charge_details.each do |band_charge_detail|
          order_rows.concat(initial_compliance_charge_row(registration, band_charge_detail).compact)
          order_rows.concat(additional_compliance_charge_row(registration, band_charge_detail).compact)
        end
        # farm compliance charge row
        order_rows.concat(farm_compliance_charge_row(registration, charge_detail).compact)
        # charge adjustment rows
        registration.account.charge_adjustments.map do |charge_adjustment|
          order_rows.concat(charge_adjustment_row(registration, charge_adjustment).compact)
        end
        # payment rows
        registration.account.payments.map do |payment|
          order_rows.concat(payment_row(registration, payment).compact)
        end
        order_rows
      end

      def initial_compliance_charge_row(registration, secondary_object)
        return [] unless secondary_object.initial_compliance_charge_amount.positive?

        presenter = FinanceDataReport::InitialComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                               total: @total)

        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @total = presenter.total
        [output]
      end

      def additional_compliance_charge_row(registration, secondary_object)
        return [] unless secondary_object.additional_compliance_charge_amount.positive?

        presenter = FinanceDataReport::AdditionalComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                                  total: @total)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @total = presenter.total
        [output]
      end

      def farm_compliance_charge_row(registration, secondary_object)
        return [] unless secondary_object.bucket_charge_amount.positive?

        presenter = FinanceDataReport::FarmComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                            total: @total)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @total = presenter.total
        [output]
      end

      def registration_charge_row(registration, secondary_object)
        presenter = FinanceDataReport::RegistrationChargeRowPresenter.new(registration:, secondary_object:,
                                                                          total: @total)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @total = presenter.total
        [output]
      end

      def charge_adjustment_row(registration, secondary_object)
        presenter = FinanceDataReport::ChargeAdjustmentRowPresenter.new(registration:, secondary_object:,
                                                                        total: @total)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        [output]
      end

      def payment_row(registration, secondary_object)
        presenter = FinanceDataReport::PaymentRowPresenter.new(registration:, secondary_object:, total: @total)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        [output]
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
