# frozen_string_literal: true

require "rails_helper"

RSpec.describe PromoteToServiceManagerService do
  let(:service) { described_class.new }
  let(:email) { "test.user@example.com" }
  let!(:user) { create(:user, email: email, role: "admin_team_user", active: true) }
  let(:logger) { instance_spy(Logger) }

  before do
    allow(Logger).to receive(:new).and_return(logger)
  end

  describe "#run" do
    context "when the input is valid" do
      it "promotes the user to service manager" do
        expect { service.run(email) }.to change { user.reload.role }
          .from("admin_team_user").to("service_manager")
      end

      it "logs a success message" do
        service.run(email)
        expect(logger).to have_received(:info)
          .with("Successfully promoted user #{email} from admin_team_user to service_manager")
      end

      it "returns true" do
        expect(service.run(email)).to be true
      end
    end

    context "when email is blank" do
      it "returns false and logs error message" do
        result = service.run("")

        expect(logger).to have_received(:info).with("Error: Email address is required")
        expect(result).to be false
      end
    end

    context "when user does not exist" do
      let(:nonexistent_email) { "nonexistent@example.com" }

      it "returns false and logs error message" do
        result = service.run(nonexistent_email)

        expect(logger).to have_received(:info).with("Error: No user found with email #{nonexistent_email}")
        expect(result).to be false
      end
    end

    context "when user is inactive" do
      let!(:inactive_user) { create(:user, email: "inactive@example.com", role: "admin_team_user", active: false) }

      it "returns false and logs error message" do
        result = service.run(inactive_user.email)

        expect(logger).to have_received(:info).with("Error: User #{inactive_user.email} is not active")
        expect(result).to be false
      end
    end

    context "when user is already a service manager" do
      let!(:service_manager) { create(:user, email: "service.manager@example.com", role: "service_manager", active: true) }

      it "returns false and logs informative message" do
        result = service.run(service_manager.email)

        expect(logger).to have_received(:info).with("User #{service_manager.email} is already a service manager")
        expect(result).to be false
      end
    end

    context "when role update fails" do
      before do
        allow(User).to receive(:find_by).and_return(user)
        allow(user).to receive_messages(save: false, errors: instance_double(ActiveModel::Errors, full_messages: ["Role update failed"]))
      end

      it "returns false and logs error message" do
        result = service.run(email)

        expect(logger).to have_received(:info).with("Error: Failed to update user role: Role update failed")
        expect(result).to be false
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow(User).to receive(:find_by).and_return(user)
        allow(user).to receive(:save).and_raise(StandardError.new("Unexpected error"))
      end

      it "returns false and logs error message" do
        result = service.run(email)

        expect(logger).to have_received(:info)
          .with("Error: An unexpected error occurred while updating the user role: Unexpected error")
        expect(result).to be false
      end
    end
  end
end
