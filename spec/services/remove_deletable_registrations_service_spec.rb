# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemoveDeletableRegistrationsService do
  let!(:expired_8_years_ago) do
    Timecop.freeze(8.years.ago) do
      create(:registration, :with_ceased_exemptions)
    end
  end

  let!(:recently_expired) do
    create(:registration, :with_ceased_exemptions)
  end

  describe ".run" do
    it "removes registrations expired > 7 years ago" do
      expect(WasteExemptionsEngine::Registration.all).to eq(
        [
          expired_8_years_ago,
          recently_expired
        ]
      )

      described_class.run

      expect(WasteExemptionsEngine::Registration.all).to eq(
        [recently_expired]
      )
    end
  end
end
