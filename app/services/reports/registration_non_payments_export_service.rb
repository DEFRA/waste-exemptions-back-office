# frozen_string_literal: true

require "csv"

module Reports
  class RegistrationNonPaymentsExportService < WasteExemptionsEngine::BaseService

    COLUMNS = {
      reference: "WEX number",
      operator_name: "Organisation name",
      amount_owed_in_pounds: "Amount owed",
      days_since_registration: "Days since registration"
    }.freeze

    def run
      CSV.generate do |csv|
        csv << COLUMNS.values
        RegistrationNonPaymentsService.run.each do |registration|
          csv << present_row(registration)
        end
      end
    end

    private

    def present_row(registration)
      presenter = RegistrationNonPaymentPresenter.new(registration)
      COLUMNS.map { |column, _heading| presenter.send(column) }
    end
  end
end
