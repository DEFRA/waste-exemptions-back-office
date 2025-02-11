# frozen_string_literal: true

module Reports
  class GeneratedReport < WasteExemptionsEngine::ApplicationRecord
    self.table_name = :reports_generated_reports

    REPORT_TYPE_BULK = "bulk"
    REPORT_TYPE_FINANCE_DATA = "finance_data"
    REPORT_TYPES = [REPORT_TYPE_BULK, REPORT_TYPE_FINANCE_DATA].freeze

    scope :bulk, -> { where(report_type: REPORT_TYPE_BULK) }
    scope :finance_data, -> { where(report_type: REPORT_TYPE_FINANCE_DATA) }

    validates :report_type, presence: true, inclusion: { in: REPORT_TYPES }
  end
end
