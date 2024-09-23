# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bulk seed registrations", type: :rake do
  include_context "rake"

  describe "bulk_seed_registration_exemptions" do

    after do
      Rake::Task["cleanup:transient_registrations"].reenable
    end

    it "runs without error" do
      expect do
        Rake::Task["bulk_seed_registration_exemptions"].invoke(3)
      end.not_to raise_error
    end

  end
end
