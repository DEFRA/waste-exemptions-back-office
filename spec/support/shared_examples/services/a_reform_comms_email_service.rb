# frozen_string_literal: true

# Needs registrations, expected_send_args, receipt_status and run_service sending to "contact@example.com".
RSpec.shared_examples "a reform comms email service" do

  let(:notify_client) { instance_double(Notifications::Client) }
  let(:notify_response) do
    instance_double(Notifications::Client::ResponseNotification,
                    id: "notification-id",
                    content: { "subject" => "Waste exemptions are changing", "body" => "Email body" })
  end

  before do
    allow(Notifications::Client).to receive(:new).and_return(notify_client)
    allow(notify_client).to receive(:send_email).and_return(notify_response)
  end

  it "sends the email to the contact email address" do
    run_service

    expect(notify_client).to have_received(:send_email).with(expected_send_args)
  end

  it "returns the Notify response" do
    expect(run_service).to eq(notify_response)
  end

  it "records the email in the communication history of each registration" do
    run_service

    registrations.each do |registration|
      expect(registration.reload.communication_logs.sole).to have_attributes(
        message_type: "email",
        template_id: described_class::TEMPLATE_ID,
        template_label: described_class::TEMPLATE_LABEL,
        sent_to: "contact@example.com",
        notification_id: "notification-id",
        subject: "Waste exemptions are changing",
        body: "Email body"
      )
    end
  end

  context "when Notify sends the delivery receipt for the email" do
    before do
      run_service

      WasteExemptionsEngine::NotifyCallbackJob.perform_now(
        "id" => "notification-id",
        "to" => "contact@example.com",
        "status" => receipt_status,
        "notification_type" => "email"
      )
    end

    it "updates the status in the communication history of each registration" do
      registrations.each do |registration|
        expect(registration.reload.communication_logs.sole.status).to eq(receipt_status)
      end
    end
  end

end
