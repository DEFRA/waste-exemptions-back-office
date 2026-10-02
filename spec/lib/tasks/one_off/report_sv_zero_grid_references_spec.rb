# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:report_sv_zero_grid_references", type: :rake do
  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:report_sv_zero_grid_references"] }
  let(:registration) { create(:registration) }
  let(:site_address) { registration.site_address }
  let(:grid_only_site) do
    create(:address, :site_address, registration:, grid_reference: "SV 00000 00000", x: 0.0, y: 0.0)
  end

  before do
    site_address.update!(
      mode: :lookup,
      grid_reference: "sv00000 00000",
      postcode: "BS1 5AH",
      uprn: "340116",
      x: 0.0,
      y: 0.0
    )
    grid_only_site
    create(:address, :site_address, registration:, grid_reference: "ST 58337 72855")
  end

  after { rake_task.reenable }

  it "reports lookup and grid-reference entries with their available location data" do
    expect { rake_task.invoke }.to output(
      include(
        "Matching site addresses: 2",
        "mode=lookup postcode_present=true uprn_present=true count=1",
        "mode=auto postcode_present=false uprn_present=false count=1",
        "registration=#{registration.reference.inspect} address_id=#{site_address.id}",
        'postcode="BS1 5AH" uprn="340116" x=0.0 y=0.0',
        "registration=#{registration.reference.inspect} address_id=#{grid_only_site.id}",
        "postcode=nil uprn=nil x=0.0 y=0.0",
        "Renewal links and retained site history (read-only):",
        '"type":"renewal_chain"',
        '"complete":true',
        '"type":"registration_history"',
        '"retained_versions":0'
      )
    ).to_stdout
  end

  it "prints retained site snapshots from the affected registration and its original" do
    original = create(:registration)
    registration.update!(referring_registration: original)
    PaperTrail::Version.create!(
      item_type: "WasteExemptionsEngine::Registration", item_id: original.id, event: "update",
      json: { addresses: [original.site_address.attributes] }.to_json, whodunnit: "public user"
    )

    expect { rake_task.invoke }.to output(
      include(
        "\"newest_to_oldest\":[#{registration.reference.to_json},#{original.reference.to_json}]",
        "\"type\":\"site_history\",\"registration\":#{original.reference.to_json}",
        '"recorded_author":"public user"',
        '"grid_reference":"ST 58337 72855"'
      )
    ).to_stdout
  end
end
