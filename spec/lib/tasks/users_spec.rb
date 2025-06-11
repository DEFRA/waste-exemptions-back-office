# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users:deactivate_inactive_users", type: :rake do
  include_context "rake"
  let(:rake_task) { Rake::Task["users:deactivate_inactive_users"] }
  let(:active_user) { create(:user, active: true, role:) }

  after { rake_task.reenable }

  it { expect { rake_task.invoke }.not_to raise_error }

  context "when the user has not signed in for over 3 months" do
    let(:role) { "data_viewer" }

    before { active_user.update(last_sign_in_at: 3.months.ago) }

    context "when the user has no last logged in timestamp" do
      before do
        active_user.update(last_sign_in_at: nil)
      end

      it "deactivates the user if the user has been invited more than 3 moths ago" do
        active_user.update(invitation_sent_at: 1.year.ago)
        expect { rake_task.invoke }.to change { active_user.reload.active }.to(false)
      end

      it "does not deactivate the user if the user has been invited less than 3 moths ago" do
        active_user.update(invitation_sent_at: 1.day.ago)
        expect { rake_task.invoke }.not_to change { active_user.reload.active }
      end
    end

    context "when the user has last logged in timestamp" do
      before do
        active_user.update(last_sign_in_at: 1.year.ago)
      end

      it "deactivates the user" do
        expect { rake_task.invoke }.to change { active_user.reload.active }.to(false)
      end
    end

    context "when the user is a data_viewer" do
      it "deactivates the user" do
        expect { rake_task.invoke }.to change { active_user.reload.active }.to(false)
      end
    end

    context "when the user is an admin_team_user" do
      let(:role) { "admin_team_user" }

      it "does not deactivate the user" do
        expect { rake_task.invoke }.not_to change { active_user.reload.active }
      end
    end

    context "when the user is a developer" do
      let(:role) { "developer" }

      it "does not deactivate the user" do
        expect { rake_task.invoke }.not_to change { active_user.reload.active }
      end
    end
  end

  context "when the user has signed in within the last 3 months" do
    let(:role) { "data_viewer" }

    before do
      active_user.update(last_sign_in_at: 1.month.ago, role:)
    end

    it "does not deactivate the user" do
      expect { rake_task.invoke }.not_to change { active_user.reload.active }
    end
  end

  describe "dry run mode" do
    let(:role) { "data_viewer" }

    before { active_user.update(last_sign_in_at: 3.months.ago) }

    it "does not deactivate the user" do
      expect { rake_task.invoke("dry_run") }.not_to change { active_user.reload.active }
    end
  end
end
