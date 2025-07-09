# frozen_string_literal: true

# > RegistrationChangeHistoryService.run(reg)
# Example output:
# [
#   {
#     :date=>Fri, 21 Mar 2025 15:57:04.005744000 GMT +00:00,
#     :changed=>[
#       ['~', 'contact_first_name', 'Johnny', 'John'],
#       ['-', 'contact_last_name', 'Smiths', ''],
#       ['+', 'contact_position', '', 'Senior Manager']
#     ],
#     :reason_for_change=>"Fixing the typo in name",
#     :changed_by=>"developer@wex.gov.uk"
#   }
#   ...
# ]
class RegistrationChangeHistoryService < WasteExemptionsEngine::BaseService

  REGISTRATION_ATTRIBUTES = %i[
    reference
    location
    applicant_first_name
    applicant_last_name
    applicant_phone
    applicant_email
    business_type
    operator_name
    company_no
    contact_first_name
    contact_last_name
    contact_position
    contact_phone
    contact_email
    on_a_farm
    is_a_farmer
  ].freeze

  def run(registration)
    # exclude all versions up until placeholder value gets changed from true to false
    # but no more than 2 versions
    ids_to_exclude = version_ids_to_exclude(registration)
    registration.versions.where.not(id: ids_to_exclude).includes(:item).map do |version|
      version_changes(version)
    end.compact
  end

  private

  def version_ids_to_exclude(registration)
    placeholder_change_version = find_placeholder_change_version(registration)
    # return first 2 versions if placeholder_change_version is nil
    return registration.versions.first(2).map(&:id) unless placeholder_change_version

    registration.versions.select { |v| v.id <= placeholder_change_version.id }.map(&:id)
  end

  def find_placeholder_change_version(registration)
    registration.versions.find do |v|
      v.object_changes&.include?("placeholder") &&
        v.object_changes["placeholder"][0] == true &&
        v.object_changes["placeholder"][1] == false
    end
  end

  def version_changes(version)
    return if version.changeset.nil?

    changes = filtered_changes(version)
    return if changes.empty?

    build_change_details(version, changes)
  end

  def filtered_changes(version)
    older_version_json = version.previous&.json
    newer_version_json = version.json
    changes = AuditTrailDiffService.run(older_version_json:, newer_version_json:)
    changes.select { |c| relevant_change?(c) }
  end

  def relevant_change?(change)
    REGISTRATION_ATTRIBUTES.include?(change[1].to_sym) ||
      change[1].include?("addresses.") ||
      change[1].include?("registration_exemptions.")
  end

  def build_change_details(version, changes)
    {
      date: version.created_at,
      changed: changes,
      reason_for_change: reason_for_change(version, changes),
      changed_by: changed_by(version)
    }
  end

  def reason_for_change(version, changes)
    if changes.any? { |change| change[1].include?("registration_exemptions.") }
      return registration_exemption_reason(version)
    end

    (version.next.present? ? version.next.reify.reason_for_change : version.item.reason_for_change) || nil
  end

  def registration_exemption_reason(version)
    JSON.parse(version.json)["registration_exemptions"].first["reason_for_change"] || nil
  end

  def changed_by(version)
    return "System" unless version.whodunnit
    return "Public user" if version.whodunnit == "public user"

    identifier?(version.whodunnit) ? User.find(version.whodunnit).email : version.whodunnit
  end

  def identifier?(whodunnit)
    true if Integer(whodunnit)
  rescue StandardError
    false
  end
end
