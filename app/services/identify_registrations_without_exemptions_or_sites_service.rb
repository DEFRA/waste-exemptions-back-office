# frozen_string_literal: true

# Identifies non-placeholder registrations that are missing exemptions and/or
# site addresses. Returns one report row (hash) per registration
class IdentifyRegistrationsWithoutExemptionsOrSitesService < WasteExemptionsEngine::BaseService
  def run
    registrations.map { |registration| row_for(registration) }
  end

  private

  def registrations
    site_type = WasteExemptionsEngine::Address.address_types.fetch(:site)

    WasteExemptionsEngine::Registration
      .where(placeholder: false)
      .select(
        "registrations.id",
        "registrations.reference",
        "(SELECT COUNT(*) FROM registration_exemptions re " \
        "WHERE re.registration_id = registrations.id) AS exemptions_count",
        "(SELECT COUNT(*) FROM addresses a " \
        "WHERE a.registration_id = registrations.id AND a.address_type = #{site_type}) AS sites_count"
      )
      .where(
        "NOT EXISTS (SELECT 1 FROM registration_exemptions re " \
        "WHERE re.registration_id = registrations.id) " \
        "OR NOT EXISTS (SELECT 1 FROM addresses a " \
        "WHERE a.registration_id = registrations.id AND a.address_type = #{site_type})"
      )
  end

  def row_for(registration)
    {
      "ID" => registration.id,
      "Reference" => registration.reference,
      "Status" => status_for(registration),
      "Exemptions" => registration.exemptions_count,
      "Sites" => registration.sites_count
    }
  end

  def status_for(registration)
    return "no_exemptions" if registration.registration_exemptions.empty?

    registration.state
  end
end
