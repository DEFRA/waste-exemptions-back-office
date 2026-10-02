# frozen_string_literal: true

require "rails_helper"

RSpec.describe SvZeroGridReferenceHistoryService do
  subject(:report) { described_class.run(registrations: [registration]) }

  let(:registration) { create(:registration) }
  let(:site) { registration.site_address }
  let(:snapshot) do
    {
      "reference" => registration.reference,
      "assistance_mode" => "full",
      "addresses" => [site.attributes],
      "contact_email" => "private@example.com",
      "renew_token" => "private-token"
    }
  end

  def create_version(json: nil, object: nil, at: Time.current, author: nil)
    PaperTrail::Version.create!(
      item_type: "WasteExemptionsEngine::Registration",
      item_id: registration.id,
      event: "update",
      json:,
      object:,
      created_at: at,
      whodunnit: author
    )
  end

  it "reports the current location and explicitly reports missing history" do
    expect(report).to include(
      include(type: "registration_history", retained_versions: 0, archived_versions: 0,
              current_sites: [include("grid_reference" => site.grid_reference)])
    )
    expect(report.select { |row| row[:type] == "site_history" }).to be_empty
  end

  it "follows renewal links through multiple generations" do
    original = create(:registration)
    parent = create(:registration, referring_registration: original)
    registration.update!(referring_registration: parent)

    expect(report.first).to include(
      newest_to_oldest: [registration.reference, parent.reference, original.reference], complete: true
    )
  end

  it "prints shared ancestors' histories only once" do
    child = create(:registration, referring_registration: registration)
    rows = described_class.run(registrations: [child, registration])

    expect(rows.count { |row| row[:type] == "renewal_chain" }).to eq(2)
    expect(rows.count { |row| row[:type] == "registration_history" && row[:registration] == registration.reference }).to eq(1)
  end

  it "reports a missing parent rather than calling the retained registration the original" do
    registration.update!(referring_registration_id: 999_999_999)

    expect(report.first).to include(complete: false, missing_registration_id: 999_999_999)
  end

  it "stops and reports circular renewal links" do
    registration.update!(referring_registration_id: registration.id)

    expect(report.first).to include(complete: false, cycle_registration_id: registration.id)
  end

  it "reports stored JSON strings in chronological order with their recorded authors" do
    bad_snapshot = snapshot.deep_dup
    bad_snapshot["addresses"].first["grid_reference"] = "SV 00000 00000"
    later = create_version(json: bad_snapshot.to_json, at: 1.day.ago, author: "public user")
    earlier = create_version(json: snapshot.to_json, at: 2.days.ago, author: "staff@example.com")

    history = report.select { |row| row[:type] == "site_history" }
    expect(history.pluck(:version_id)).to eq([earlier.id, later.id])
    expect(history.last).to include(recorded_author: "public user", snapshot_kind: "recorded_snapshot",
                                    site_snapshot_available: true, sites: [include("grid_reference" => "SV 00000 00000")])
  end

  it "supports JSON objects and includes only site addresses" do
    snapshot["addresses"] << registration.contact_address.attributes
    create_version(json: snapshot)

    expect(report.last[:sites]).to eq([site.attributes.slice(*described_class::SITE_FIELDS).as_json])
  end

  it "supports numeric address types in older snapshots" do
    snapshot["addresses"].first["address_type"] = 3
    create_version(json: snapshot)

    expect(report.last[:sites]).to contain_exactly(include("grid_reference" => site.grid_reference))
  end

  it "does not expose unrelated contact details or registration tokens" do
    snapshot["addresses"] << registration.contact_address.attributes.merge("description" => "private-contact")
    create_version(json: snapshot)

    expect(report.to_json).not_to include("private@example.com", "private-token", "private-contact", "renew_token")
  end

  it "labels legacy YAML as the state before the event and preserves an unknown author" do
    create_version(object: snapshot.merge("created_at" => Date.new(2018, 1, 1)).to_yaml)

    expect(report.last).to include(snapshot_kind: "before_event", recorded_author: nil,
                                   site_snapshot_available: true, sites: [include("grid_reference" => site.grid_reference)])
  end

  it "reports legacy records without embedded site data as missing site snapshots" do
    create_version(object: { "reference" => registration.reference }.to_yaml)

    expect(report.last).to include(site_snapshot_available: false, sites: [])
  end

  it "reports malformed JSON without preventing other history from being read" do
    create_version(json: "not JSON", at: 2.days.ago)
    create_version(json: snapshot, at: 1.day.ago)

    history = report.select { |row| row[:type] == "site_history" }
    expect(history.first).to include(site_snapshot_available: false, snapshot_error: "JSON::ParserError")
    expect(history.last).to include(site_snapshot_available: true)
  end

  it "does not deserialize arbitrary Ruby objects from legacy history" do
    create_version(object: "--- !ruby/object:Object {}")

    expect(report.last).to include(site_snapshot_available: false, snapshot_error: "Psych::DisallowedClass")
  end

  it "includes archived versions alongside the current history" do
    archive_class = Class.new(WasteExemptionsEngine::ApplicationRecord) { self.table_name = "version_archives" }
    archive = archive_class.create!(
      item_type: "WasteExemptionsEngine::Registration", item_id: registration.id,
      event: "update", object: snapshot.to_yaml, whodunnit: "legacy user", created_at: 5.years.ago
    )
    create_version(json: snapshot)

    history = report.select { |row| row[:type] == "site_history" }
    expect(history.first).to include(source: "version_archives", version_id: archive.id, recorded_author: "legacy user",
                                     snapshot_kind: "before_event", site_snapshot_available: true)
  end

  it "does not modify registrations, addresses or their versions" do
    create_version(json: snapshot)
    before_data = [registration.reload.attributes, site.reload.attributes, registration.versions.map(&:attributes)]

    report

    expect([registration.reload.attributes, site.reload.attributes, registration.versions.map(&:attributes)]).to eq(before_data)
  end

  it "reads the snapshots produced by WEX's audit trail", :versioning do
    site.update!(grid_reference: "SV 00000 00000", x: 0.0, y: 0.0)
    registration.addresses.reload
    PaperTrail.request(whodunnit: "public user") { registration.paper_trail.save_with_version }

    expect(report.last).to include(
      recorded_author: "public user", site_snapshot_available: true,
      sites: [include("grid_reference" => "SV 00000 00000", "x" => 0.0, "y" => 0.0)]
    )
  end
end
