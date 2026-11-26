# frozen_string_literal: true

# Needs registrations, letter_args (the arguments to run, sending to Jane Smith at Acme Ltd, 1, High Street,
# Bristol, BS1 1AA for the registrations), run_service, and notify_client returned by Notifications::Client.new
# with send_letter stubbed to return notify_response.
RSpec.shared_examples "a reform comms letter service" do

  it "returns the Notify response" do
    expect(run_service).to eq(notify_response)
  end

  it "records the letter in the communication history of each registration" do
    run_service

    registrations.each do |registration|
      expect(registration.reload.communication_logs.sole).to have_attributes(
        message_type: "letter",
        template_id: described_class::TEMPLATE_ID,
        template_label: described_class::TEMPLATE_LABEL,
        sent_to: "Jane Smith, Acme Ltd, 1, High Street, Bristol, BS1 1AA",
        notification_id: notify_response.id,
        body: notify_response.content["body"]
      )
    end
  end

  context "when Notify rejects the letter" do
    let(:error) do
      Notifications::Client::BadRequestError.new(
        instance_double(Net::HTTPResponse,
                        code: "400",
                        body: { errors: [{ error: "ValidationError", message: "Rejected by Notify" }] }.to_json)
      )
    end

    before { allow(notify_client).to receive(:send_letter).and_raise(error) }

    it "records the rejection in the communication history of each registration and raises the error" do
      expect { run_service }.to raise_error(error)

      registrations.each do |registration|
        expect(registration.reload.communication_logs.sole).to have_attributes(
          template_id: described_class::TEMPLATE_ID,
          template_label: described_class::TEMPLATE_LABEL,
          status: "permanent-failure"
        )
      end
    end
  end

  it_behaves_like "CanHaveCommunicationLog" do
    let(:service_class) { described_class }
    let(:parameters) { letter_args.merge(registrations: [create(:registration)]) }
  end

end
