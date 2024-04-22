# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "opted out of renewal reminder" do
  let(:registration) { create(:registration, reminder_opt_in: false) }
  it "does not send an email" do
    expect(run_service).not_to be_a(Notifications::Client::ResponseNotification)
  end

  it "creates an opted out communication log" do
    run_service

    log_instance = WasteExemptionsEngine::CommunicationLog.first

    expect(log_instance.message_type).to eq "email"
    expect(log_instance.template_id).to be_nil
    expect(log_instance.template_label).to eq "User is opted out - No renewal reminder email sent"
    expect(log_instance.sent_to).to eq registration.contact_email
  end

  it "still sends an email if skip_opted_out_check is true" do
    VCR.use_cassette("first_renewal_reminder_email") do
      expect(described_class.run(registration: registration, skip_opted_out_check: true)).to be_a(Notifications::Client::ResponseNotification)
    end
  end
end
