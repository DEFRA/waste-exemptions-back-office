# frozen_string_literal: true

module Reports
  class Download < WasteExemptionsEngine::ApplicationRecord
    self.table_name = :reports_downloads

    belongs_to :report, polymorphic: true, optional: false

    validates :user_id, presence: true
    validates :downloaded_at, presence: true
  end
end
