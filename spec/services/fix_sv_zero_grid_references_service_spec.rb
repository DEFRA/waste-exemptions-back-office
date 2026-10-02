# frozen_string_literal: true

require "rails_helper"

RSpec.describe FixSvZeroGridReferencesService do
  subject(:run_service) { described_class.run(dry_run:) }

  let(:dry_run) { true }
  let(:registration) { create(:registration) }
  let(:site_address) { registration.site_address }
  let(:lookup_result) do
    {
      "uprn" => 340_116,
      "x" => 358_337.0,
      "y" => 172_855.0
    }
  end
  let(:lookup_response) do
    instance_double(DefraRuby::Address::Response, successful?: true, results: [lookup_result])
  end

  before do
    site_address.update!(
      mode: :lookup,
      grid_reference: "SV 00000 00000",
      x: 0.0,
      y: 0.0,
      postcode: "BS1 5AH",
      uprn: "340116",
      area: nil
    )

    allow(WasteExemptionsEngine::AddressLookupService).to receive(:run)
      .with("BS1 5AH")
      .and_return(lookup_response)
    allow(WasteExemptionsEngine::DetermineGridReferenceService).to receive(:run)
      .with(easting: 358_337.0, northing: 172_855.0)
      .and_return("ST 58337 72855")
    allow(WasteExemptionsEngine::DetermineAreaService).to receive(:run)
      .with(easting: 358_337.0, northing: 172_855.0)
      .and_return("Wessex")
    allow(RecordSiteLocationFixHistoryService).to receive(:run)
  end

  context "when running in dry-run mode" do
    it "reports a recoverable address without updating it" do
      expect { run_service }.not_to change { site_address.reload.attributes }
    end

    it "does not record change history" do
      run_service

      expect(RecordSiteLocationFixHistoryService).not_to have_received(:run)
    end
  end

  context "when running in live-run mode" do
    let(:dry_run) { false }

    it "updates coordinates, grid reference and EA area" do
      run_service

      expect(site_address.reload).to have_attributes(
        x: 358_337.0,
        y: 172_855.0,
        grid_reference: "ST 58337 72855",
        area: "Wessex"
      )
    end

    it "records registration change history" do
      run_service

      expect(RecordSiteLocationFixHistoryService).to have_received(:run).with(registration:)
    end
  end

  context "when the postcode lookup returns several addresses" do
    let(:lookup_response) do
      instance_double(
        DefraRuby::Address::Response,
        successful?: true,
        results: [
          { "uprn" => 999_999, "x" => 111_111.0, "y" => 222_222.0 },
          lookup_result
        ]
      )
    end

    it "uses the result matching the stored UPRN instead of the first result" do
      run_service

      expect(WasteExemptionsEngine::DetermineGridReferenceService).to have_received(:run)
        .with(easting: 358_337.0, northing: 172_855.0)
    end
  end

  context "when there is no exact UPRN match" do
    let(:lookup_response) do
      instance_double(
        DefraRuby::Address::Response,
        successful?: true,
        results: [{ "uprn" => 999_999, "x" => 111_111.0, "y" => 222_222.0 }]
      )
    end

    it "leaves the address unresolved and unchanged" do
      expect { run_service }.not_to change { site_address.reload.attributes }
    end
  end

  context "when several results have the stored UPRN" do
    let(:lookup_response) do
      instance_double(
        DefraRuby::Address::Response,
        successful?: true,
        results: [lookup_result, lookup_result.merge("x" => 358_338.0)]
      )
    end

    it "leaves the ambiguous address unresolved" do
      expect { run_service }.not_to change { site_address.reload.attributes }
    end
  end

  context "when the stored address has no UPRN" do
    before { site_address.update!(uprn: nil) }

    it "leaves the address unchanged without looking up the postcode" do
      expect { run_service }.not_to change { site_address.reload.attributes }
      expect(WasteExemptionsEngine::AddressLookupService).not_to have_received(:run)
    end
  end

  context "when the lookup fails" do
    let(:lookup_response) do
      instance_double(DefraRuby::Address::Response, successful?: false, results: [])
    end

    it "leaves the address unresolved" do
      expect { run_service }.not_to change { site_address.reload.attributes }
    end
  end

  context "when the matched result has invalid coordinates" do
    let(:lookup_result) { { "uprn" => 340_116, "x" => 0.0, "y" => 0.0 } }

    it "leaves the address unresolved" do
      expect { run_service }.not_to change { site_address.reload.attributes }
    end
  end

  context "when the matched coordinates have no EA area" do
    before do
      allow(WasteExemptionsEngine::DetermineAreaService).to receive(:run).and_return(nil)
    end

    it "leaves the address unresolved" do
      expect { run_service }.not_to change { site_address.reload.attributes }
    end
  end

  context "when an unexpected error occurs" do
    before do
      allow(WasteExemptionsEngine::AddressLookupService).to receive(:run).and_raise(StandardError, "lookup failed")
      allow(Airbrake).to receive(:notify)
    end

    it "reports the error without changing the address" do
      expect { run_service }.not_to(change { site_address.reload.attributes })
      expect(Airbrake).to have_received(:notify)
    end
  end

  context "when recording change history fails during a live run" do
    let(:dry_run) { false }

    before do
      allow(RecordSiteLocationFixHistoryService).to receive(:run).and_raise(StandardError, "history failed")
      allow(Airbrake).to receive(:notify)
    end

    it "rolls back the site location update" do
      expect { run_service }.not_to change { site_address.reload.attributes }
      expect(Airbrake).to have_received(:notify)
    end
  end

  context "with other site locations" do
    before do
      create(:address, :site_address, registration:, grid_reference: "ST 58337 72855")
      create(:address, :site_address, registration:, grid_reference: "SV 00001 00001")
    end

    it "checks only SV 00000 00000, including whitespace variants" do
      site_address.update!(grid_reference: "sv00000 00000")

      run_service

      expect(WasteExemptionsEngine::AddressLookupService).to have_received(:run).once
    end
  end
end
