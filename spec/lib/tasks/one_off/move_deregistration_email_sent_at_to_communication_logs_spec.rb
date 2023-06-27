# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:move_deregistration_email_sent_at_to_communication_logs", type: :rake do
  subject(:rake_task) { Rake::Task["one_off:move_deregistration_email_sent_at_to_communication_logs"] }

  include_context "rake"

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  let(:not_set_registrations) { create_list(:registration, 2, deregistration_email_sent_at: nil) }
  let(:set_registrations) { create_list(:registration, 5, deregistration_email_sent_at: Time.zone.now) }
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

  describe "batch size configuration" do

    context "with the default batch size" do
      it "processes all registraitons" do
        rake_task.invoke

        expect(registration_count_with_attribute).to be_zero
      end
    end

    context "with a specified batch size lower than the number of qualifying registrations" do
      it "runs the service with the specified lead time" do
        rake_task.invoke(3)

        expect(registration_count_with_attribute).to eq 2
      end
    end
  end
end
