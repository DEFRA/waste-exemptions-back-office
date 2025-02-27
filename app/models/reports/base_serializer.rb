# frozen_string_literal: true

require "csv"

module Reports
  class BaseSerializer
    def to_csv
      CSV.generate do |csv|
        csv << self.class::ATTRIBUTES

        exemptions_data do |exemption_data|
          csv << exemption_data
        end
      end
    end

    private

    def exemptions_data
      registration_exemptions_scope.find_in_batches(batch_size: batch_size) do |batch|
        batch.each do |registration_exemption|
          yield parse_registration_exemption(registration_exemption)
        rescue StandardError => e
          # Handle parsing errors here so that the serializer can continue with the next object.
          message = "EPR serializer: Error mapping registration_exemption #{registration_exemption.id}, " \
                    "registration #{registration_exemption.registration.reference}: #{e}"
          Rails.logger.error message
          Airbrake.notify(e, message:)
        end
      end
    end

    def batch_size
      WasteExemptionsBackOffice::Application.config.export_batch_size.to_i
    end
  end
end
