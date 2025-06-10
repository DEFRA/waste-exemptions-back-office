# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:govpay_signature", type: :rake do
  subject(:run_rake_task) { rake_task.invoke(body) }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:govpay_signature"] }
  let(:body) { "test_body" }

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  before do
    allow(DefraRubyGovpay.configuration).to receive_messages(front_office_webhook_signing_secret: "foo", back_office_webhook_signing_secret: "foo")
  end

  it { expect { run_rake_task }.not_to raise_error }

  context "when Rails environment is production" do
    before do
      allow(Rails.env).to receive(:production?).and_return(true)
    end

    it "aborts with production mode error" do
      expect { run_rake_task }.to output("/The Rails environment is running in production mode!/").to_stderr
    end
  end

end
