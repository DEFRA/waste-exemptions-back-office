# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cleanup task", type: :rake do
  include_context "rake"

  describe "cleanup:transient_registrations" do
    let(:rake_task) { Rake::Task["cleanup:transient_registrations"] }
    let(:old_registration) { create(:new_charged_registration, created_at: 31.days.ago) }
    let(:env_limit) { "1" }

    before do
      old_registration
      create(:new_charged_registration, created_at: 31.days.ago)
      create(:new_charged_registration)
      allow(ENV).to receive(:fetch).with("TRANSIENT_REGISTRATION_CLEANUP_LIMIT", any_args).and_return(env_limit)
    end

    after { rake_task.reenable }

    it { expect { rake_task.invoke }.not_to raise_error }

    it "deletes only up to the environment variable limit number of old transient registrations" do
      expect { rake_task.invoke }.to change {
        WasteExemptionsEngine::TransientRegistration
          .where(created_at: ...30.days.ago)
          .count
      }.from(2).to(1)
    end
  end

  describe "cleanup:placeholder_registrations" do
    let(:rake_task) { Rake::Task["cleanup:placeholder_registrations"] }
    let!(:placeholder_registration) { create(:registration, placeholder: true, created_at: 31.days.ago) }
    let(:env_limit) { "1" }

    before do
      placeholder_registration
      create(:registration, placeholder: false, created_at: 31.days.ago)
      create(:registration, placeholder: true, created_at: 31.days.ago)
      create(:registration, placeholder: true)
      # We use the same limit as the transient_registration cleanup task
      allow(ENV).to receive(:fetch).with("TRANSIENT_REGISTRATION_CLEANUP_LIMIT", any_args).and_return(env_limit)
    end

    after { rake_task.reenable }

    it { expect { rake_task.invoke }.not_to raise_error }

    it "does not delete non-placeholder registrations" do
      expect { rake_task.invoke }.not_to change {
        WasteExemptionsEngine::Registration
          .where.not(placeholder: true)
          .count
      }
    end

    it "deletes only up to the environment variable limit number of old placeholder registrations" do
      expect { rake_task.invoke }.to change {
        WasteExemptionsEngine::Registration
          .where(placeholder: true, created_at: ...30.days.ago)
          .count
      }.from(2).to(1)
    end
  end
end
