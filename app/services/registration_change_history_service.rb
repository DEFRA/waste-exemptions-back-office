# frozen_string_literal: true

# > RegistrationChangeHistoryService.run(reg)
# Example output:
# [
#   {
#     :date=>Fri, 21 Mar 2025 15:57:04.005744000 GMT +00:00,
#     :changed_to=>[
#       {:contact_first_name=>"John"},
#       {:contact_last_name=>"Smith"},
#       {:contact_position=>"Senior Manager"}
#     ],
#     :changed_from=>[
#       {:contact_first_name=>"Johnny"},
#       {:contact_last_name=>"Smiths"},
#       {:contact_position=>"Manager"}
#     ],
#     :reason_for_change=>"Fixing the typo in name",
#     :changed_by=>"developer@wex.gov.uk"
#   }
#   ...
# ]
class RegistrationChangeHistoryService < WasteExemptionsEngine::BaseService
  def run(registration)
    registration.versions.map do |version|
      version_changes(version)
    end.compact
  end

  private

  def version_changes(version)
    return if version.reify.nil?

    changesets = version.reify.changes.except(:updated_at, :reason_for_change)
    {
      date: version.created_at,
      changed_to: changesets.map { |key, changeset| { "#{key}": changeset[0] } },
      changed_from: changesets.map { |key, changeset| { "#{key}": changeset[1] } },
      reason_for_change: reason_for_change(version),
      changed_by: changed_by(version)
    }
  end

  def reason_for_change(version)
    version.reify.changes["reason_for_change"].present? ? version.reify.changes["reason_for_change"].first : nil
  end

  def changed_by(version)
    version.whodunnit ? User.find(version.whodunnit).email : "System"
  end
end
