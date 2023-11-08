# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cleanup task", type: :rake do
  include_context "rake"

  describe "cleanup:transient_registrations" do
    before do
      @old_registration = create(:new_registration, created_at: 31.days.ago)
      create(:new_registration, created_at: 31.days.ago)
      create(:new_registration)
    end

    it "deletes only up to the limit number of old transient registrations" do
      expect { subject.invoke(1) }.to change {
        [WasteExemptionsEngine::TransientRegistration
          .where("created_at < ?", 30.days.ago)
          .count,
         WasteExemptionsEngine::TransientRegistration
           .where("created_at > ?", 30.days.ago)
           .count]
      }.from([2, 1]).to([1, 1])
    end

    it "runs without error" do
      expect { subject.invoke }.not_to raise_error
    end
  end
end
