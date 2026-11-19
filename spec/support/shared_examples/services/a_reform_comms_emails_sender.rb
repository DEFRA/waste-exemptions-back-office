# frozen_string_literal: true

# Needs service, output, dry_run, notify_client, totals_label and registrations_by_email.
RSpec.shared_examples "a reform comms emails sender" do

  let(:emails_to_send) { registrations_by_email.keys }
  let(:first_email) { emails_to_send.first }
  let(:last_email) { emails_to_send.last }
  let(:first_email_registrations) { registrations_by_email.fetch(first_email) }
  let(:registration_count) { registrations_by_email.values.sum(&:size) }

  let(:rate_limit_error) do
    Notifications::Client::RateLimitError.new(
      instance_double(Net::HTTPResponse,
                      code: "429",
                      body: { errors: [{ error: "RateLimitError", message: "Exceeded rate limit" }] }.to_json)
    )
  end

  it "sends one email to each contact email address, and no others" do
    service

    expect(notify_client).to have_received(:send_email).exactly(emails_to_send.size).times
    emails_to_send.each do |email_address|
      expect(notify_client).to have_received(:send_email).with(hash_including(email_address:)).once
    end
  end

  it "returns the number of emails sent" do
    expect(service).to eq(emails_to_send.size)
  end

  it "outputs the number of emails sent and the registrations they cover" do
    service

    expect(output.string).to eq("#{totals_label} sent: #{emails_to_send.size}\n" \
                                "Registrations covered: #{registration_count}\n")
  end

  it "shows the email in the communication history of every registration with that contact email" do
    service

    registrations_by_email.each do |email_address, registrations|
      registrations.each do |registration|
        expect(registration.reload.communication_logs.max_by(&:id).notification_id)
          .to eq("#{email_address}-notification-id")
      end
    end
  end

  context "when there are more emails than fit in one batch" do
    let(:service_instance) { described_class.new }

    before do
      stub_const("#{described_class}::RATE_LIMIT", 2) # batches of 1 email
      allow(described_class).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:sleep)
    end

    it "sends every email" do
      expect(service).to eq(emails_to_send.size)
    end

    it "waits a minute between batches to stay within the Notify rate limit" do
      service

      expect(service_instance).to have_received(:sleep)
        .with(a_value_within(1).of(60)).exactly(emails_to_send.size - 1).times
    end

    context "when it is a dry run" do
      let(:dry_run) { true }

      it "does not wait between batches" do
        service

        expect(service_instance).not_to have_received(:sleep)
      end
    end
  end

  context "when Notify rejects an email for exceeding a limit" do
    before do
      allow(notify_client).to receive(:send_email)
        .with(hash_including(email_address: first_email))
        .and_raise(rate_limit_error)
    end

    it "stops sending" do
      service

      expect(notify_client).not_to have_received(:send_email).with(hash_including(email_address: last_email))
    end

    it "reports the error to Airbrake once" do
      service

      expect(Airbrake).to have_received(:notify).once
      expect(Airbrake).to have_received(:notify).with(rate_limit_error)
    end

    it "returns the number of emails sent before it stopped" do
      expect(service).to eq(0)
    end
  end

  context "when sending an email fails" do
    before do
      allow(notify_client).to receive(:send_email)
        .with(hash_including(email_address: first_email))
        .and_raise(StandardError, "Notify error")
    end

    it "reports the error to Airbrake with the registrations it was for" do
      service

      expect(Airbrake).to have_received(:notify)
        .with(an_instance_of(StandardError),
              registration: first_email_registrations.map(&:reference).join(", "))
    end

    it "carries on sending to the other contact email addresses" do
      service

      expect(notify_client).to have_received(:send_email).with(hash_including(email_address: last_email))
    end

    it "does not record the failed email in the communication history" do
      service

      first_email_registrations.each do |registration|
        expect(registration.reload.communication_logs.map(&:notification_id))
          .not_to include("#{first_email}-notification-id")
      end
    end

    it "does not count the failed email or its registrations" do
      expect(service).to eq(emails_to_send.size - 1)
      expect(output.string)
        .to include("Registrations covered: #{registration_count - first_email_registrations.size}\n")
    end
  end

  context "when it is a dry run" do
    let(:dry_run) { true }

    it "does not send any emails" do
      service

      expect(notify_client).not_to have_received(:send_email)
    end

    it "does not record anything in the communication history" do
      expect { service }.not_to change(WasteExemptionsEngine::CommunicationLog, :count)
    end

    it "returns the number of emails that would be sent" do
      expect(service).to eq(emails_to_send.size)
    end

    it "outputs each email with the registrations it would be sent for, then the totals" do
      service

      # Listed in the order they are sent, so registrations_by_email has to be in that order too
      listed = registrations_by_email.map do |email_address, registrations|
        "#{email_address} (#{registrations.size}): #{registrations.map(&:reference).join(', ')}\n"
      end

      expect(output.string).to eq("#{listed.join}#{totals_label} to send: #{emails_to_send.size}\n" \
                                  "Registrations covered: #{registration_count}\n")
    end
  end

end
