# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendDeregistrationEmailBatchJob do
  subject(:job) { described_class.new }

  let(:test_batch_size) { 1 }

  let(:feature_toggle_state) { true }

  around do |example|
    old_batch_size = Rails.configuration.registration_email_batch_size
    old_queue_adapter = ActiveJob::Base.queue_adapter
    Rails.configuration.registration_email_batch_size = test_batch_size
    ActiveJob::Base.queue_adapter = :test
    example.run
  ensure
    Rails.configuration.registration_email_batch_size = old_batch_size
    ActiveJob::Base.queue_adapter = old_queue_adapter
  end

  before do
    allow(WasteExemptionsEngine::FeatureToggle)
      .to receive(:active?).and_return(feature_toggle_state)
  end

  describe "#perform" do
    context "with valid registrations" do
      let(:registrations) { create_list(:registration, 3, :eligible_for_deregistration) }

      let(:test_batch_size) { 2 }

      before { registrations }

      it "enqueues the correct number of email jobs" do
        job.perform

        expect(SendDeregistrationEmailJob).to have_been_enqueued.exactly(test_batch_size)
      end

      it "drops the created temporary table" do
        job.perform

        res = ActiveRecord::Base.connection.execute <<-SQL.squish
          SELECT exists (
            SELECT FROM information_schema.tables
            WHERE table_name = '#{SendDeregistrationEmailBatchJob::TEMP_TABLE_NAME}');
        SQL

        expect(res.first.fetch("exists")).to be(false)
      end
    end

    context "with the feature toggle disabled" do
      let(:registrations) { create_list(:registration, 3, :eligible_for_deregistration) }

      let(:feature_toggle_state) { false }

      before { registrations }

      it "enqueues the correct number of email jobs" do
        job.perform

        expect(SendDeregistrationEmailJob).to have_been_enqueued.exactly(0)
      end
    end

    context "with a batch size larger than the number of registrations" do
      let(:registrations) { create_list(:registration, 3, :eligible_for_deregistration) }

      let(:test_batch_size) { registrations.size * 2 }

      before { registrations }

      it "enqueues the correct number of email jobs" do
        job.perform

        expect(SendDeregistrationEmailJob).to have_been_enqueued.exactly(registrations.size)
      end

      it "does not enqueue duplicate jobs for the registrations" do
        job.perform

        queued_ids = SendDeregistrationEmailJob.queue_adapter.enqueued_jobs.map do |job|
          job[:args].first
        end

        expect(queued_ids.sort).to eq(registrations.map(&:id).sort)
      end
    end

    context "when the de-registration email has already been sent" do
      let(:registration) do
        create(:registration, :eligible_for_deregistration, deregistration_email_sent_at: Time.zone.now)
      end

      before { registration }

      it "does not enqueue any jobs" do
        job.perform

        expect(SendDeregistrationEmailJob).to have_been_enqueued.exactly(0)
      end
    end

    context "when the registration has been submitted too recently" do
      let(:registration) do
        create(:registration, :eligible_for_deregistration, submitted_at: 1.day.ago)
      end

      before { registration }

      it "does not enqueue any jobs" do
        job.perform

        expect(SendDeregistrationEmailJob).to have_been_enqueued.exactly(0)
      end
    end

    context "when no exemptions are active" do
      let(:registration) do
        create(
          :registration,
          :eligible_for_deregistration,
          registration_exemptions: build_list(:registration_exemption, 1, :ceased)
        )
      end

      before { registration }

      it "does not enqueue any jobs" do
        job.perform

        expect(SendDeregistrationEmailJob).to have_been_enqueued.exactly(0)
      end
    end

    context "when all exemptions are within the renewal window" do
      let(:registration) do
        create(
          :registration,
          :eligible_for_deregistration,
          registration_exemptions: build_list(:registration_exemption, 1, expires_on: Date.yesterday)
        )
      end

      before { registration }

      it "does not enqueue any jobs" do
        job.perform

        expect(SendDeregistrationEmailJob).to have_been_enqueued.exactly(0)
      end
    end
  end
end
