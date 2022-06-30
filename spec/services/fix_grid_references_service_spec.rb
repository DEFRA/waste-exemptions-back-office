# frozen_string_literal: true

require "rails_helper"

RSpec.describe FixGridReferencesService do
  subject(:service) { described_class.run }

  let(:wrong_ngr) { create(:address, :with_grid_reference, y: 1, mode: :lookup) }
  let(:right_ngr) { create(:address, :with_grid_reference) }
  let(:auto_ngr)  { create(:address, :with_grid_reference, y: 1, mode: :auto) }

  describe ".run" do
    it "updates the bad NGR" do
      expect { service }.to change { wrong_ngr.reload.grid_reference }.from("ST 58337 72855").to("SY 58337 00001")
    end

    it "does not update the good NGR" do
      expect { service }.to_not change { right_ngr.reload.grid_reference }
    end

    it "does not update the auto NGR" do
      expect { service }.to_not change { auto_ngr.reload.grid_reference }
    end
  end
end
