# frozen_string_literal: true

module Reports
  module FinanceDataReport
    class DataSerializer
      ATTRIBUTES = %i[
        registration_number
        date
        charge_type
        charge_amount
        charge_band
      ].freeze

      def to_csv
        CSV.generate do |csv|
          csv << self.class::ATTRIBUTES

          registrations_scope.find_in_batches(batch_size: batch_size) do |batch|
            batch.each do |registration|

              # registration charge row
              charge_detail = registration.account.orders.last.charge_detail
              csv << registration_charge_row(registration, charge_detail)

              registration.account.orders.last.charge_detail.band_charge_details.each do |band_charge_detail|
                # initial compliance charge row
                csv << initial_compliance_charge_row(registration, band_charge_detail)
                # additional compliance charge row
                csv << additional_compliance_charge_row(registration, band_charge_detail)
              end

              registration.account.charge_adjustments.each do |charge_adjustment|
                # charge adjustment row
                csv << charge_adjustment_row(registration, charge_adjustment)
              end

              # registration empty row
              csv << registration_empty_row(registration)
            end
          end
        end
      end

      private

      def initial_compliance_charge_row(registration, secondary_object)
        ATTRIBUTES.map do |attribute|
          presenter = FinanceDataReport::InitialComplianceChargeRowPresenter.new(registration:, secondary_object:)
          presenter.public_send(attribute)
        end
      end

      def additional_compliance_charge_row(registration, secondary_object)
        ATTRIBUTES.map do |attribute|
          presenter = FinanceDataReport::AdditionalComplianceChargeRowPresenter.new(registration:, secondary_object:)
          presenter.public_send(attribute)
        end
      end

      def registration_charge_row(registration, secondary_object)
        ATTRIBUTES.map do |attribute|
          presenter = FinanceDataReport::RegistrationChargeRowPresenter.new(registration:, secondary_object:)
          presenter.public_send(attribute)
        end
      end

      def charge_adjustment_row(registration, secondary_object)
        ATTRIBUTES.map do |attribute|
          presenter = FinanceDataReport::ChargeAdjustmentRowPresenter.new(registration:, secondary_object:)
          presenter.public_send(attribute)
        end
      end

      def registration_empty_row(registration)
        ATTRIBUTES.map do |attribute|
          presenter = FinanceDataReport::BaseRegistrationRowPresenter.new(registration:)
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
