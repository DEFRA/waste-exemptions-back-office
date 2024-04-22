# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cleanup task", type: :rake do
  include_context "rake"

  describe "cleanup:transient_registrations" do
    let(:old_registration) { create(:new_registration, created_at: 31.days.ago) }
    let(:env_limit) { "1" }

    before do
      old_registration
      create(:new_registration, created_at: 31.days.ago)
      create(:new_registration)
      allow(ENV).to receive(:fetch).with("TRANSIENT_REGISTRATION_CLEANUP_LIMIT", any_args).and_return(env_limit)
    end

    after do
      Rake::Task["cleanup:transient_registrations"].reenable
    end

    it "deletes only up to the environment variable limit number of old transient registrations" do
      expect do
        Rake::Task["cleanup:transient_registrations"].invoke
      end.to change {
        WasteExemptionsEngine::TransientRegistration
          .where("created_at < ?", 30.days.ago)
          .count
      }.from(2).to(1)
    end

    it "runs without error" do
      expect do
        Rake::Task["cleanup:transient_registrations"].invoke
      end.not_to raise_error
    end

  end
end
