# frozen_string_literal: true

module Reports
  class GeneratedReport < WasteExemptionsEngine::ApplicationRecord
    self.table_name = :reports_generated_reports
  end
end
