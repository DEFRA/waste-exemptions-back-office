# frozen_string_literal: true

require "yaml"

class SvZeroGridReferenceHistoryService < WasteExemptionsEngine::BaseService
  REGISTRATION_FIELDS = %w[
    id reference created_at submitted_at assistance_mode referring_registration_id placeholder reason_for_change
  ].freeze
  SITE_FIELDS = %w[id mode grid_reference x y postcode uprn area description source_data_type created_at].freeze

  def run(registrations:)
    @reported_ids = []

    registrations.flat_map do |registration|
      chain, status = renewal_chain(registration)
      chain_row = {
        type: "renewal_chain",
        registration: registration.reference,
        newest_to_oldest: chain.map(&:reference)
      }.merge(status)

      [chain_row] + chain.flat_map { |ancestor| registration_rows(ancestor) }
    end
  end

  private

  def renewal_chain(registration)
    chain = []
    current = registration

    loop do
      if chain.any? { |item| item.id == current.id }
        return [chain, { complete: false, cycle_registration_id: current.id }]
      end

      chain << current
      previous_id = current.referring_registration_id
      return [chain, { complete: true }] unless previous_id

      current = current.referring_registration
      return [chain, { complete: false, missing_registration_id: previous_id }] unless current
    end
  end

  def registration_rows(registration)
    return [] if @reported_ids.include?(registration.id)

    @reported_ids << registration.id
    versions = registration.versions.map { |version| version.attributes.merge("source" => "versions") }
    archives = archived_versions(registration)
    summary = {
      type: "registration_history",
      registration: registration.reference,
      current: registration.attributes.slice(*REGISTRATION_FIELDS),
      current_sites: site_details(registration.addresses.map(&:attributes)),
      retained_versions: versions.size,
      archived_versions: archives.size
    }
    history = (versions + archives).sort_by { |version| [version["created_at"] || Time.zone.at(0), version["id"]] }

    [summary] + history.map { |version| version_row(registration, version) }
  end

  def archived_versions(registration)
    query = [
      "SELECT id, created_at, event, whodunnit, object FROM version_archives WHERE item_type = ? AND item_id = ?",
      "WasteExemptionsEngine::Registration",
      registration.id
    ]
    sql = WasteExemptionsEngine::Registration.sanitize_sql_array(query)
    ActiveRecord::Base.connection.select_all(sql).map { |version| version.merge("source" => "version_archives") }
  end

  def version_row(registration, version)
    {
      type: "site_history",
      registration: registration.reference,
      source: version["source"],
      version_id: version["id"],
      at: version["created_at"],
      event: version["event"],
      recorded_author: version["whodunnit"]
    }.merge(snapshot_details(version))
  end

  def snapshot_details(version)
    recorded_snapshot = version["json"].present?
    kind = recorded_snapshot ? "recorded_snapshot" : "before_event"
    data = snapshot_data(version, recorded_snapshot)

    {
      snapshot_kind: kind,
      site_snapshot_available: data.is_a?(Hash) && data["addresses"].is_a?(Array),
      registration_fields: data.is_a?(Hash) ? data.slice(*REGISTRATION_FIELDS) : {},
      sites: data.is_a?(Hash) ? site_details(data["addresses"]) : []
    }
  rescue JSON::ParserError, Psych::Exception => e
    { snapshot_kind: kind, site_snapshot_available: false, snapshot_error: e.class.name, sites: [] }
  end

  def snapshot_data(version, recorded_snapshot)
    if recorded_snapshot
      data = version["json"]
      data.is_a?(String) ? JSON.parse(data) : data
    elsif version["object"].present?
      # PaperTrail's object is the state BEFORE the event, not the updated state.
      YAML.safe_load(
        version["object"],
        permitted_classes: [Date, Time, DateTime, ActiveSupport::TimeZone, ActiveSupport::TimeWithZone],
        aliases: true
      )
    end
  end

  def site_details(addresses)
    return [] unless addresses.is_a?(Array)

    addresses.filter_map do |address|
      next unless address.is_a?(Hash) && ["site", 3, "3"].include?(address["address_type"])

      address.slice(*SITE_FIELDS)
    end
  end
end
