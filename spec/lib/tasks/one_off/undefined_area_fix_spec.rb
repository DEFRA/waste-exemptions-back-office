# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:undefined_area_fix", type: :rake do

  subject(:run_rake_task) { rake_task.invoke }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:undefined_area_fix"] }

  let(:reg_with_postcode_that_can_be_found) do
    reg1 = create(:registration, :site_uses_address, :with_manual_site_address, created_at: 1.year.ago)
    reg1.site_address.update(postcode: "WA16 0AW", area: nil)
    reg1
  end

  let(:reg_with_postcode_that_cannot_be_found) do
    reg2 = create(:registration, :site_uses_address, :with_manual_site_address, created_at: 1.year.ago)
    reg2.site_address.update(postcode: "PE33 0NE", area: nil)
    reg2
  end

  let(:coords) { { easting: 123.4, northing: 123.5 } }

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  it "updates the area for a registration with a site address postcode that can be found" do
    allow(WasteExemptionsEngine::DetermineEastingAndNorthingService).to receive(:run).with(grid_reference: nil, postcode: "WA16 0AW").and_return(coords)
    allow(WasteExemptionsEngine::DetermineAreaService).to receive(:run).and_return("Yorkshire")
    expect { run_rake_task }.to change { reg_with_postcode_that_can_be_found.site_address.reload.area }.to "Yorkshire"
  end

  it "updates the area for a registration with a site address postcode that cannot be found" do
    allow(WasteExemptionsEngine::DetermineEastingAndNorthingService).to receive(:run).with(grid_reference: nil, postcode: "PE33 0NE").and_return(nil)
    allow(WasteExemptionsEngine::DetermineEastingAndNorthingService).to receive(:run).with(grid_reference: nil, postcode: "PE33 0N").and_return(coords)
    allow(WasteExemptionsEngine::DetermineAreaService).to receive(:run).and_return("Lincolnshire and Northamptonshire")
    expect { run_rake_task }.to change { reg_with_postcode_that_cannot_be_found.site_address.reload.area }.to "Lincolnshire and Northamptonshire"
  end
end
