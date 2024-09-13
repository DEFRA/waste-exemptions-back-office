# frozen_string_literal: true

module Reports
  class TrackDownloadService < ::WasteExemptionsEngine::BaseService
    def run(report:, user:)
      Reports::Download.create!(
        report: report,
        user_id: user&.id,
        downloaded_at: Time.zone.now
      )
    end
  end
end
