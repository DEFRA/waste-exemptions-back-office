# frozen_string_literal: true

module Reports
  class Download < WasteExemptionsEngine::ApplicationRecord
    self.table_name = :reports_downloads

    validates :report_type, presence: true
    validates :report_file_name, presence: true
    validates :user_id, presence: true
    validates :downloaded_at, presence: true
  end
end
