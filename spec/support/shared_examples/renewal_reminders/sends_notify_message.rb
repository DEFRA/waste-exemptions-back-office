# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "sends a Notify message with the correct template id" do
  it do
    VCR.use_cassette(cassette_name) do
      result = run_service

      expect(result).to be_a(Notifications::Client::ResponseNotification)
      expect(result.template["id"]).to eq(template_id)
    end
  end
end

RSpec.shared_examples "includes a renewal link" do
  it do
    VCR.use_cassette(cassette_name) do
      expect(run_service.content["body"]).to match(%r{http://localhost:\d+/renew/})
    end
  end
end

RSpec.shared_examples "creates a communication log" do
  it do
    VCR.use_cassette(cassette_name) do
      expect { run_service }.to change { registration.communication_logs.count }.by(1)
    end
  end
end

RSpec.shared_examples "sends a Notify message with the correct template id and with a renewal link" do
  it_behaves_like "sends a Notify message with the correct template id"
  it_behaves_like "includes a renewal link"
  it_behaves_like "creates a communication log"
end

RSpec.shared_examples "does not include a renewal link" do
  it do
    VCR.use_cassette(cassette_name) do
      expect(run_service.content["body"]).not_to match(%r{http://localhost:\d+/renew/})
    end
  end
end

RSpec.shared_examples "sends a Notify message with the correct template id and without a renewal link" do
  it_behaves_like "sends a Notify message with the correct template id"
  it_behaves_like "does not include a renewal link"
end

RSpec.shared_examples "sends a legacy bulk / multi-site renewal reminder email" do
  if WasteExemptionsEngine::FeatureToggle.active?(:enable_renewals)
    it_behaves_like "sends a Notify message with the correct template id and without a renewal link" do
      let(:cassette_name) { "renewal_reminder_email_multisite_enable_renewals_off" }
      let(:template_id) { "69a8254e-2bd0-4e09-b27a-ad7e8a29d783" }
    end
  else
    it_behaves_like "sends a Notify message with the correct template id and with a renewal link" do
      let(:cassette_name) { "renewal_reminder_email_multisite_enable_renewals_on" }
      let(:template_id) { "cda801d8-ad08-4e77-ab46-94b0e9689ed7" }
    end
  end
end

RSpec.shared_examples "legacy bulk or multisite reminder" do
  context "when the registration is legacy bulk" do
    before { registration.update(is_legacy_bulk: true) }

    it_behaves_like "sends a legacy bulk / multi-site renewal reminder email"
  end

  context "when the registration is multi-site" do
    before { registration.update(is_multisite_registration: true) }

    it_behaves_like "sends a legacy bulk / multi-site renewal reminder email"
  end
end
