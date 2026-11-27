# frozen_string_literal: true

require "rails_helper"

RSpec.describe FollowUpReformCommsEmailService do
  describe ".run" do
    subject(:run_service) { described_class.run(email: "contact@example.com", registrations:) }

    let(:registrations) { create_list(:registration, 2, contact_email: "contact@example.com") }

    it_behaves_like "a reform comms email service" do
      let(:expected_send_args) do
        { email_address: "contact@example.com", template_id: described_class::TEMPLATE_ID,
          reference: a_kind_of(String) }
      end
      let(:receipt_status) { "permanent-failure" }
    end

    it_behaves_like "calls notify with reference" do
      let(:send_action) { :send_email }
      let(:reference) { a_kind_of(String) }
    end

    it "uses the same Notify template as the original reform comms email" do
      expect(described_class::TEMPLATE_ID).to eq(OctoberReformCommsEmailService::TEMPLATE_ID)
    end

    it "labels it so it can be told apart from the original reform comms email" do
      expect(described_class::TEMPLATE_LABEL).not_to eq(OctoberReformCommsEmailService::TEMPLATE_LABEL)
    end
  end
end
