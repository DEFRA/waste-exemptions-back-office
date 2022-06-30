# frozen_string_literal: true

require "rails_helper"

RSpec.describe FixGridReferencesService do
  subject(:service) { described_class.run }
  # should correct to SY 58337 00001
  # NGR = national grid reference
  let(:wrong_ngr) { create(:address, :site_using_grid_reference, y: 1) }
  let(:right_ngr) { create(:address, :site_using_grid_reference) }
  
  describe ".run" do
    it "does not error" do
      service
    end
  end
end
