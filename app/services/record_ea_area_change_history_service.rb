# frozen_string_literal: true

class RecordEaAreaChangeHistoryService < WasteExemptionsEngine::BaseService
  CHANGE_REASON = "EA area checked and updated"
  VERSION_AUTHOR = "System"

  def run(registration:)
    PaperTrail.request(whodunnit: VERSION_AUTHOR) do
      registration.reason_for_change = CHANGE_REASON
      registration.addresses.reload
      registration.paper_trail.save_with_version
    end
  end
end
