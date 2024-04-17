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
    expect(log_instance.template_id).to eq "N/A"
    expect(log_instance.template_label).to eq "USER OPTED OUT - NO RENEWAL REMINDER EMAIL SENT"
    expect(log_instance.sent_to).to eq registration.contact_email
  end
end
