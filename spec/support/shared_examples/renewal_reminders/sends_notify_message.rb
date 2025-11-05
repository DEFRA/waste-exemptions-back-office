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

RSpec.shared_examples "sends a Notify message with the correct template id and with a renewal link" do
  it_behaves_like "sends a Notify message with the correct template id"
  it_behaves_like "includes a renewal link"
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
