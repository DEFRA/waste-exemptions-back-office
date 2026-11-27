# frozen_string_literal: true

require "rails_helper"

RSpec.describe OctoberReformCommsEmailService do
  describe ".run" do
    subject(:run_service) { described_class.run(email: "contact@example.com", registrations:) }

    let(:registrations) { create_list(:registration, 2, contact_email: "contact@example.com") }

    it_behaves_like "a reform comms email service" do
      let(:expected_send_args) do
        { email_address: "contact@example.com", template_id: described_class::TEMPLATE_ID,
          reference: a_kind_of(String) }
      end
      let(:receipt_status) { "delivered" }
    end

    it "labels the email as the October send" do
      expect(described_class::TEMPLATE_LABEL).to eq("Reform comms email - October 2026")
    end
  end
end
