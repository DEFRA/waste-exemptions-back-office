# frozen_string_literal: true

require "rails_helper"

RSpec.describe "govpay test tasks", type: :rake do
  include_context "rake"

  original_stdout = $stdout
  original_stderr = $stderr

  before do
    # suppress noisy outputs during unit test
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  after do
    $stdout = original_stdout
    $stderr = original_stderr
  end

  describe "test:govpay:signature" do

    subject(:run_rake_task) { rake_task.invoke("test_body") }

    let(:rake_task) { Rake::Task["test:govpay:signature"] }
    let(:user) { create(:user) }

    # By default Rails prevents multiple invocations of the same Rake task in succession
    after { rake_task.reenable }

    it { expect { run_rake_task }.not_to raise_error }

    context "when Rails environment is production" do
      before do
        allow(Rails.env).to receive(:production?).and_return(true)
      end

      it "aborts with production mode error" do
        expect { Rake::Task[rake_task].invoke("test_body") }.to raise_error(SystemExit, "The Rails environment is running in production mode!")
      end
    end

    context "when Rails environment is not production" do
      before do
        allow(Rails.env).to receive(:production?).and_return(false)
      end

      context "when body argument is missing" do
        it "aborts with missing body error" do
          expect { Rake::Task[rake_task].invoke(nil) }.to raise_error(SystemExit, "missing body argument")
        end
      end

      context "when body argument is provided" do
        let(:body) { '{"refund_id":"ref88888","created_date":"2025-06-09T16:52:41.178Z","amount":"2000","status":"success","settlement_summary":{},"payment_id":"8mj0ov91v18apmgjf3jurfuc8d"}' }
        let(:expected_signature) { "ab05f80fb1cc6dc26eeb309b9c82da1517942df5ab81d921190d0284febe8e35" }

        it "runs without error" do
          expect { Rake::Task[rake_task].invoke(body) }.not_to raise_error
        end

        it "calls DefraRubyGovpay::WebhookSignatureService with the correct body" do
          allow(DefraRubyGovpay::WebhookSignatureService).to receive(:run)
          Rake::Task[rake_task].invoke(body)
          expect(DefraRubyGovpay::WebhookSignatureService).to have_received(:run).with(body: body)
        end

        it "generates a valid signature" do
          allow(DefraRubyGovpay.configuration).to receive(:front_office_webhook_signing_secret).and_return("foo")

          # Capture output when running the rake task
          output = StringIO.new
          original_stdout = $stdout
          $stdout = output

          # Run the rake task
          Rake::Task[rake_task].invoke(body)

          # Restore stdout and get the output
          $stdout = original_stdout
          captured_output = output.string

          Rails.logger.debug { "Captured output: #{captured_output}" }

          # Extract signature from output
          signature_match = captured_output.match(/:front_office=>\s*"(.*?)"/)[1]
          expect(signature_match).to eq(expected_signature)
        end
      end
    end
  end
end
