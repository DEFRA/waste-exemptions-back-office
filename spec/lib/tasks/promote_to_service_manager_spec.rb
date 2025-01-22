# frozen_string_literal: true

require "rails_helper"

RSpec.describe "user:promote_to_service_manager rake task", type: :rake do
  include_context "rake"

  describe "promote_to_service_manager" do
    subject(:task) { Rake::Task["user:promote_to_service_manager"] }

    before { allow(PromoteToServiceManagerService).to receive(:run) }

    let(:email) { "test.user@example.com" }

    it "calls the service with the email parameter" do
      task.invoke(email)
      expect(PromoteToServiceManagerService).to have_received(:run).with(email)
    end
  end
end
