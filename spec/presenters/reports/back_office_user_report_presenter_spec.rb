# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BackOfficeUserReportPresenter do
    subject(:presenter) { described_class.new(user) }

    describe "#status" do
      context "with an active user" do
        let(:user) { build(:user, active: true) }

        it { expect(presenter.status).to eq("Active") }
      end

      context "with an invited user" do
        let(:user) do
          build(:user, active: true, invitation_token: "foobar")
        end

        it { expect(presenter.status).to eq("Invitation Sent") }
      end

      context "with a deactivated user" do
        let(:user) { build(:user, active: false) }

        it { expect(presenter.status).to eq("Deactivated") }
      end
    end

    describe "#last_sign_in_at" do
      context "with a previously signed in user" do
        let(:user) { build(:user, active: false, last_sign_in_at: Time.zone.at(0)) }

        it { expect(presenter.last_sign_in_at).to eq("01/01/1970 01:00") }
      end

      context "with a user that never signed in" do
        let(:user) { build(:user, active: false, last_sign_in_at: nil) }

        it { expect(presenter.last_sign_in_at).to be_nil }
      end
    end
  end
end
