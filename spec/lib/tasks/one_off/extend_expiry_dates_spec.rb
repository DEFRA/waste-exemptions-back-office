# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:extend_expiry_dates", type: :rake do
  include_context "rake"

  describe "one_off:extend_expiry_dates:active_t28_registrations" do
    subject(:run_rake_task) { rake_task.invoke }

    let(:rake_task) { Rake::Task["one_off:extend_expiry_dates:active_t28_registrations"] }

    let(:t28_exemption) { WasteExemptionsEngine::Exemption.find_by(code: "T28") || create(:exemption, code: "T28") }
    let(:registration_exemption) { create(:registration_exemption, exemption: t28_exemption, expires_on: "2025-03-28") }
    let(:registration) { create(:registration, registration_exemptions: [registration_exemption]) }

    let(:registration_out_of_scope) { create(:registration, :with_ceased_exemptions) }

    before do
      registration
      registration_out_of_scope
    end

    # By default Rails prevents multiple invocations of the same Rake task in succession
    after { rake_task.reenable }

    it { expect { run_rake_task }.not_to raise_error }

    it { expect { run_rake_task }.to change { registration_exemption.reload.expires_on.strftime("%Y-%m-%d") }.to "2025-09-28" }
    it { expect { run_rake_task }.not_to change { registration_out_of_scope.registration_exemptions.first.reload.expires_on } }

    context "when the task is run with a custom date range" do
      it { expect { rake_task.invoke("2025-04-15", "2025-05-15") }.not_to change { registration_exemption.reload.expires_on } }
      it { expect { rake_task.invoke("2025-03-15", "2025-04-15") }.to change { registration_exemption.reload.expires_on.strftime("%Y-%m-%d") }.to "2025-09-28" }
    end
  end

  describe "one_off:extend_expiry_dates:active_charity_registrations" do
    subject(:run_rake_task) { rake_task.invoke }

    let(:rake_task) { Rake::Task["one_off:extend_expiry_dates:active_charity_registrations"] }

    let(:registration) { create(:registration, :with_active_exemptions, business_type: "charity") }
    let(:registration_out_of_scope) { create(:registration, :with_ceased_exemptions) }

    before do
      registration.registration_exemptions.first.update(expires_on: "2025-03-28")
      registration_out_of_scope
    end

    # By default Rails prevents multiple invocations of the same Rake task in succession
    after { rake_task.reenable }

    it { expect { run_rake_task }.not_to raise_error }

    it { expect { run_rake_task }.to change { registration.reload.expires_on.strftime("%Y-%m-%d") }.to "2025-09-28" }
    it { expect { run_rake_task }.not_to change { registration_out_of_scope.registration_exemptions.first.reload.expires_on } }

    context "when the task is run with a custom date range" do
      it { expect { rake_task.invoke("2025-04-15", "2025-05-15") }.not_to change { registration.reload.expires_on } }
      it { expect { rake_task.invoke("2025-03-15", "2025-04-15") }.to change { registration.reload.expires_on.strftime("%Y-%m-%d") }.to "2025-09-28" }
    end
  end
end
