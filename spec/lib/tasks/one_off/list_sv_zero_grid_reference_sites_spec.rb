# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:list_sv_zero_grid_reference_sites", type: :rake do
  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:list_sv_zero_grid_reference_sites"] }
  let(:lookup_registration) { create(:registration) }
  let(:grid_registration) { create(:registration) }
  let(:unaffected_registration) { create(:registration) }

  before do
    lookup_registration.site_address.update!(
      mode: :lookup, grid_reference: "sv00000 00000", postcode: "BS1 5AH", uprn: "340116", x: 0.0, y: 0.0
    )
    grid_registration.site_address.update!(
      mode: :auto, grid_reference: "SV 00000 00000", postcode: nil, uprn: nil, x: 0.0, y: 0.0
    )
    unaffected_registration
  end

  after { rake_task.reenable }

  it "lists affected sites with the action needed" do
    expect { rake_task.invoke }.to output(
      include(
        "registration,registration_state,site_active,action",
        "#{lookup_registration.reference},active,yes,Fix in back office using the address finder",
        "#{grid_registration.reference},active,yes,Contact customer for the site location"
      )
    ).to_stdout
  end

  it "does not list unaffected sites" do
    expect { rake_task.invoke }.not_to output(include(unaffected_registration.reference)).to_stdout
  end

  context "when the registration is no longer active" do
    before { grid_registration.registration_exemptions.each { |exemption| exemption.update!(state: "expired") } }

    it "lists the site as not active after the active sites" do
      expect { rake_task.invoke }.to output(
        /#{lookup_registration.reference},active,yes.*\n#{grid_registration.reference},expired,no,Contact customer/
      ).to_stdout
    end
  end
end
