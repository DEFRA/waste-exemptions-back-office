# frozen_string_literal: true

module Reports
  class GeneratedReport < WasteExemptionsEngine::ApplicationRecord
    self.table_name = :reports_generated_reports

    REPORT_TYPE_FINANCE_DATA = "finance_data"
    REPORT_TYPE_BOXI = "boxi"
    REPORT_TYPES = [REPORT_TYPE_FINANCE_DATA, REPORT_TYPE_BOXI].freeze

    scope :finance_data, -> { where(report_type: REPORT_TYPE_FINANCE_DATA) }
    scope :boxi, -> { where(report_type: REPORT_TYPE_BOXI) }

    validates :report_type, presence: true, inclusion: { in: REPORT_TYPES }
  end
end
