# frozen_string_literal: true

require "rails_helper"

RSpec.describe BackfillReformCommsLogStatusesService do
  subject(:run_service) { described_class.run(dry_run:, output:) }

  let(:dry_run) { false }
  let(:output) { StringIO.new }
  let(:template_id) { described_class::TEMPLATE_ID }

  # The logs one Notify message left behind, in the states its delivery receipt left them in
  def logs_for_one_message(statuses, **attributes)
    notification_id = SecureRandom.uuid

    statuses.map do |status|
      create(:communication_log, :email,
             { template_id:, notification_id:, sent_to: "contact@example.com", status: }.merge(attributes))
    end
  end

  def statuses_of(logs)
    logs.map { |log| log.reload.status }
  end

  describe ".run" do
    context "when the delivery receipt reached only some of a message's logs" do
      let!(:logs) { logs_for_one_message(["delivered", "sent", "sent", nil]) }

      it "gives the rest the status the message ended in" do
        run_service

        expect(statuses_of(logs)).to all(eq("delivered"))
      end

      it "reports what it changed" do
        run_service

        expect(output.string).to include("contact@example.com: 3 -> delivered",
                                         "Communication logs updated: 3")
      end

      it "returns the number of logs it updated" do
        expect(run_service).to eq(3)
      end
    end

    context "when the message failed" do
      let!(:logs) { logs_for_one_message(%w[permanent-failure sent]) }

      it "gives the rest the failure" do
        run_service

        expect(statuses_of(logs)).to all(eq("permanent-failure"))
      end
    end

    context "when no delivery receipt reached a message's logs" do
      let!(:logs) { logs_for_one_message(%w[sent sent]) }

      it "leaves them alone, as nothing records the status the message ended in" do
        expect { run_service }.not_to change { statuses_of(logs) }
      end
    end

    context "when every log for a message already holds its status" do
      let!(:logs) { logs_for_one_message(%w[delivered delivered]) }

      it "leaves them alone" do
        expect { run_service }.not_to change { statuses_of(logs) }
      end
    end

    context "with logs for another template" do
      let!(:logs) { logs_for_one_message(%w[delivered sent], template_id: "another-template-id") }

      it "leaves them alone" do
        expect { run_service }.not_to change { statuses_of(logs) }
      end
    end

    context "with logs for messages Notify never accepted" do
      let!(:logs) do
        %w[delivered sent].map { |status| create(:communication_log, :email, template_id:, status:) }
      end

      it "leaves them alone, as they do not share a notification" do
        expect { run_service }.not_to change { statuses_of(logs) }
      end
    end

    context "when it is a dry run" do
      let(:dry_run) { true }
      let!(:logs) { logs_for_one_message(%w[delivered sent]) }

      it "changes nothing" do
        expect { run_service }.not_to change { statuses_of(logs) }
      end

      it "reports what it would change" do
        run_service

        expect(output.string).to include("contact@example.com: 1 -> delivered",
                                         "Communication logs to update: 1")
      end
    end
  end
end
