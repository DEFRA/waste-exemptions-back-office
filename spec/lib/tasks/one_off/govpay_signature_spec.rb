# frozen_string_literal: true

require "rails_helper"

RSpec.describe "govpay test tasks", type: :rake do
  include_context "rake"

  describe "one_off:govpay_signature" do
    let(:rake_task) { Rake::Task["one_off:govpay_signature"] }
    let(:user) { create(:user) }

    # By default Rails prevents multiple invocations of the same Rake task in succession
    after { rake_task.reenable }

    context "when Rails environment is production" do
      before do
        allow(Rails.env).to receive(:production?).and_return(true)
      end

      it "aborts with production mode error" do
        expect { Rake::Task[rake_task].invoke("test_body") }.to output("/The Rails environment is running in production mode!/").to_stderr
      end
    end

    context "when Rails environment is not production" do
      before do
        allow(Rails.env).to receive(:production?).and_return(false)
      end

      context "when body argument is missing" do
        it "aborts with missing body error" do
          expect { Rake::Task[rake_task].invoke(nil) }.to output("/missing body argument/").to_stderr
        end
      end

      context "when body argument is provided" do
        let(:body) { '{"refund_id":"ref88888","created_date":"2025-06-09T16:52:41.178Z","amount":"2000","status":"success","settlement_summary":{},"payment_id":"8mj0ov91v18apmgjf3jurfuc8d"}' }
        let(:expected_signature) { "ab05f80fb1cc6dc26eeb309b9c82da1517942df5ab81d921190d0284febe8e35" }

        it "calls DefraRubyGovpay::WebhookSignatureService with the correct body" do
          allow(DefraRubyGovpay::WebhookSignatureService).to receive(:run)
          expect { Rake::Task[rake_task].invoke(body) }.to output(/Signature:/).to_stdout
          expect(DefraRubyGovpay::WebhookSignatureService).to have_received(:run).with(body: body)
        end

        it "generates a valid signature" do
          allow(DefraRubyGovpay.configuration).to receive_messages(front_office_webhook_signing_secret: "foo", back_office_webhook_signing_secret: "foo")
          expect { Rake::Task[rake_task].invoke(body) }.to output(/#{expected_signature}/).to_stdout
        end
      end
    end
  end
end
