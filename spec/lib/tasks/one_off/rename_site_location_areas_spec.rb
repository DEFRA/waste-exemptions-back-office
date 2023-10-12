# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:rename_site_location_areas", type: :rake do

  subject(:run_rake_task) { rake_task.invoke("area_names_20231011.csv") }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:rename_site_location_areas"] }

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  context "with a valid site location area name" do
    let(:address) { create(:address, address_type: 3, area: "Thames") }

    it { expect { run_rake_task }.not_to change { address.reload.area } }
  end

  context "with one of the designated incorrect site location area names" do
    let(:address) { create(:address, address_type: 3, area: "West Thames") }

    it { expect { run_rake_task }.to change { address.reload.area }.to("Thames") }
  end
end
