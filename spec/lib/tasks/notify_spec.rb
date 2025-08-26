# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Notify task", type: :rake do
  include_context "rake"

  describe "notify:letters:ad_renewals" do

    subject { Rake::Task["notify:letters:ad_renewals"] }

    # By default Rails prevents multiple invocations of the same Rake task in succession
    after { subject.reenable }

    it "runs without error" do
      allow(RenewalReminders::BulkRenewalLettersService).to receive(:run).and_return([build(:registration)])
      expect { subject.invoke }.not_to raise_error
    end

    describe "lead time configuration" do

      context "with the default lead time" do
        it "runs the service with the default lead time" do
          allow(RenewalReminders::BulkRenewalLettersService).to receive(:run)

          subject.invoke

          expect(RenewalReminders::BulkRenewalLettersService).to have_received(:run).with(30.days.from_now.to_date)
        end
      end

      context "with lead time set by environment variable" do

        # Rails configuration changes are global. Use an around block with a reset to avoid impacting other tests.
        around do |example|
          RSpec::Mocks.with_temporary_scope do
            previous_expires_in = WasteExemptionsBackOffice::Application.config.ad_letters_exports_expires_in
            allow(WasteExemptionsBackOffice::Application.config).to receive("ad_letters_exports_expires_in").and_return("33")
            example.run
            allow(WasteExemptionsBackOffice::Application.config).to receive("ad_letters_exports_expires_in").and_return(previous_expires_in)
          end
        end

        it "runs the service with the specified lead time" do
          allow(RenewalReminders::BulkRenewalLettersService).to receive(:run)

          subject.invoke

          expect(RenewalReminders::BulkRenewalLettersService).to have_received(:run).with(33.days.from_now.to_date)
        end
      end
    end
  end
end
