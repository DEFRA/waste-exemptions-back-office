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
        order_rows << registration_charge_row(registration, charge_detail)
        order_rows.concat(generate_band_charge_rows(registration, charge_detail))
        order_rows.concat(generate_farm_compliance_row(registration, charge_detail))
        order_rows.concat(generate_charge_adjustment_rows(registration))
        order_rows.concat(generate_payment_rows(registration))
        order_rows
      end

      def generate_band_charge_rows(registration, charge_detail)
        rows = []
        charge_detail.band_charge_details.each do |band_charge_detail|
          initial_compliance_charge_row = initial_compliance_charge_row(registration, band_charge_detail)
          rows << initial_compliance_charge_row unless initial_compliance_charge_row.empty?

          additional_compliance_charge_row = additional_compliance_charge_row(registration, band_charge_detail)
          rows << additional_compliance_charge_row unless additional_compliance_charge_row.empty?
        end
        rows
      end

      def generate_farm_compliance_row(registration, charge_detail)
        return [] unless charge_detail.bucket_charge_amount.positive?

        [farm_compliance_charge_row(registration, charge_detail)]
      end

      def generate_charge_adjustment_rows(registration)
        registration.account.charge_adjustments.map do |charge_adjustment|
          charge_adjustment_row(registration, charge_adjustment)
        end
      end

      def generate_payment_rows(registration)
        registration.account.payments.map do |payment|
          payment_row(registration, payment)
        end
      end

      def initial_compliance_charge_row(registration, secondary_object)
        presenter = FinanceDataReport::InitialComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                               total: @total)

        if presenter.exemption.present?
          output = ATTRIBUTES.map do |attribute|
            presenter.public_send(attribute)
          end
          @total = presenter.total
        else
          output = []
        end
        output
      end

      def additional_compliance_charge_row(registration, secondary_object)
        presenter = FinanceDataReport::AdditionalComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                                  total: @total)

        if presenter.exemption.present?
          output = ATTRIBUTES.map do |attribute|
            presenter.public_send(attribute)
          end
          @total = presenter.total
        else
          output = []
        end
        output
      end

      def farm_compliance_charge_row(registration, secondary_object)
        presenter = FinanceDataReport::FarmComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                            total: @total)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @total = presenter.total
        output
      end

      def registration_charge_row(registration, secondary_object)
        presenter = FinanceDataReport::RegistrationChargeRowPresenter.new(registration:, secondary_object:,
                                                                          total: @total)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @total = presenter.total
        output
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
