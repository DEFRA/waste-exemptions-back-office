# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:move_deregistration_email_sent_at_to_communication_logs", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:move_deregistration_email_sent_at_to_communication_logs"] }

  include_context "rake"

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  let(:not_set_registrations) { create_list(:registration, 2, deregistration_email_sent_at: nil) }
  let(:set_registrations) { create_list(:registration, 5, deregistration_email_sent_at: sent_time) }
  let(:sent_time) { 2.months.ago }
  let(:registration_count_with_attribute) do
    WasteExemptionsEngine::Registration.where.not(deregistration_email_sent_at: nil).count
  end

  before do
    # make sure these are instantiated
    set_registrations
    not_set_registrations
  end

  it "runs without error" do
    expect { rake_task.invoke }.not_to raise_error
  end

  context "when deregistration_email_sent_at is not set" do
    it "does not update the registration" do
      expect { rake_task.invoke }.not_to change { not_set_registrations }
    end
  end

  context "when deregistration_email_sent_at is set" do
    it "copies the expected data to communication_logs" do
      rake_task.invoke

      reg = set_registrations.last
      log = reg.communication_logs.last
      expect(log.message_type).to eq "email"
      expect(log.template_id).to eq "9148895b-e239-4118-8ffd-dadd9b2cf462"
      expect(log.template_label).to eq "Self serve exemption deregistration invite"
      expect(log.sent_to).to be_nil
      # Allow for sub-millisecond rounding
      expect(log.created_at).to be_within(0.000001.seconds).of(sent_time)
    end

    it "clears the deregistration_email_sent_at value from the registration" do
      expect { rake_task.invoke }
        .to change { WasteExemptionsEngine::Registration.where.not(deregistration_email_sent_at: nil).count }
        .to(0)
    end
  end

  describe "batch size configuration" do

    context "with the default batch size" do
      it "processes all registrations" do
        rake_task.invoke

        expect(registration_count_with_attribute).to be_zero
      end
    end

    context "with a specified batch size lower than the number of qualifying registrations" do
      it "processes only the specified number of registrations" do
        rake_task.invoke(3)

        expect(registration_count_with_attribute).to eq 2
      end
    end
  end
end
