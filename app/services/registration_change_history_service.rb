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
    return if version.changeset.nil?

    changes = version.changeset.except(
      :created_at, :updated_at, :assistance_mode,
      :view_certificate_token, :view_certificate_token_created_at, :reason_for_change,
      :submitted_at, :charged, :placeholder
    )
    return if changes.empty?

    {
      date: version.created_at,
      changed_to: changes.map { |key, changeset| { "#{key}": changeset[1] } },
      changed_from: changes.map { |key, changeset| { "#{key}": changeset[0] } },
      reason_for_change: reason_for_change(version),
      changed_by: changed_by(version)
    }
  end

  def reason_for_change(version)
    version.changeset[:reason_for_change]&.last || nil
  end

  def changed_by(version)
    return "System" unless version.whodunnit
    return "Public user" if version.whodunnit == "public user"

    User.find(version.whodunnit).email
  end
end
