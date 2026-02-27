# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class DataSerializer
      attr_accessor :total

      ATTRIBUTES = %i[
        registration_no
        date
        multisite
        organisation_name
        site
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
        payment_status
        status
      ].freeze

      def to_csv
        CSV.generate do |csv|
          csv << self.class::ATTRIBUTES

          registrations_scope.find_in_batches(batch_size: batch_size) do |batch|
            batch.each do |registration|
              next if registration&.account.blank? || registration.account.orders.none?

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

        @total = 0
        @charge_total = 0
        charge_detail = order.charge_detail

        order_rows = []
        order_rows.concat(registration_charge_row(registration, charge_detail))
        order_rows.concat(generate_compliance_charge_rows(registration, charge_detail))
        order_rows.concat(generate_charge_adjustment_rows(registration))
        order_rows.concat(generate_payment_rows(registration))
        order_rows.concat(summary_row(registration))
        order_rows
      end

      def generate_compliance_charge_rows(registration, charge_detail)
        if registration.multisite?
          generate_multisite_compliance_rows(registration, charge_detail)
        else
          generate_site_compliance_rows(registration, charge_detail, nil)
        end
      end

      def generate_multisite_compliance_rows(registration, charge_detail)
        registration.site_addresses.flat_map do |site_address|
          generate_site_compliance_rows(registration, charge_detail, site_address)
        end
      end

      def generate_site_compliance_rows(registration, charge_detail, site_address)
        rows = []

        charge_detail.band_charge_details.each do |band_charge_detail|
          rows.concat(no_compliance_charge_row(registration, band_charge_detail, site_address))
          rows.concat(initial_compliance_charge_row(registration, band_charge_detail, site_address))
          rows.concat(additional_compliance_charge_row(registration, band_charge_detail, site_address))
        end

        rows.concat(farm_compliance_charge_row(registration, charge_detail, site_address))
        rows
      end

      def generate_charge_adjustment_rows(registration)
        registration.account.charge_adjustments.flat_map do |charge_adjustment|
          charge_adjustment_row(registration, charge_adjustment, nil)
        end
      end

      def generate_payment_rows(registration)
        registration.account.payments.success.order(date_time: :asc).flat_map do |payment|
          payment_row(registration, payment, nil)
        end
      end

      def initial_compliance_charge_row(registration, secondary_object, site_address)
        return [] unless secondary_object.initial_compliance_charge_amount.positive?

        presenter = FinanceDataReport::InitialComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                               total: @total, site_address:)

        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @charge_total += presenter.summary_charge_amount_in_pence
        @total = presenter.total
        [output]
      end

      def additional_compliance_charge_row(registration, secondary_object, site_address)
        return [] unless secondary_object.additional_compliance_charge_amount.positive?

        presenter = FinanceDataReport::AdditionalComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                                  total: @total, site_address:)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @charge_total += presenter.summary_charge_amount_in_pence
        @total = presenter.total
        [output]
      end

      def farm_compliance_charge_row(registration, secondary_object, site_address)
        return [] unless secondary_object.bucket_charge_amount.positive?

        presenter = FinanceDataReport::FarmComplianceChargeRowPresenter.new(registration:, secondary_object:,
                                                                            total: @total, site_address:)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @charge_total += presenter.summary_charge_amount_in_pence
        @total = presenter.total
        [output]
      end

      def registration_charge_row(registration, secondary_object, site_address = nil)
        presenter = FinanceDataReport::RegistrationChargeRowPresenter.new(registration:, secondary_object:,
                                                                          total: @total, site_address:)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @charge_total += presenter.summary_charge_amount_in_pence
        @total = presenter.total
        [output]
      end

      def charge_adjustment_row(registration, secondary_object, site_address)
        presenter = FinanceDataReport::ChargeAdjustmentRowPresenter.new(registration:, secondary_object:,
                                                                        total: @total, site_address:)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @charge_total += presenter.summary_charge_amount_in_pence
        @total = presenter.total
        [output]
      end

      def payment_row(registration, secondary_object, site_address)
        presenter = FinanceDataReport::PaymentRowPresenter.new(registration:, secondary_object:, total: @total,
                                                               site_address:)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @total = presenter.total
        [output]
      end

      def no_compliance_charge_row(registration, secondary_object, site_address)
        initial_charge = secondary_object.initial_compliance_charge_amount.to_i
        additional_charge = secondary_object.additional_compliance_charge_amount.to_i
        return [] unless initial_charge.zero? && additional_charge.zero?

        presenter = FinanceDataReport::ComplianceNoChargeRowPresenter.new(registration:, secondary_object:,
                                                                          total: @total, site_address:)
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @charge_total += presenter.summary_charge_amount_in_pence
        @total = presenter.total
        [output]
      end

      def summary_row(registration)
        presenter = FinanceDataReport::SummaryRowPresenter.new(
          registration:,
          secondary_object: @charge_total,
          total: @total,
          show_payment_status: true
        )
        output = ATTRIBUTES.map do |attribute|
          presenter.public_send(attribute)
        end
        @total = presenter.total
        [output]
      end

      def registrations_scope
        WasteExemptionsEngine::Registration.where(submitted_at: Date.new(2025, 7, 3)..)
      end

      def batch_size
        WasteExemptionsBackOffice::Application.config.export_batch_size.to_i
      end
    end
  end
end
