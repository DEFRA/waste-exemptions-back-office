# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:change_user_roles", type: :rake do

  subject(:run_rake_task) { rake_task.invoke }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:change_user_roles"] }
  let(:user) { create(:user) }

  # By default Rails prevents multiple invocations of the same Rake task in succession
  after { rake_task.reenable }

  it { expect { run_rake_task }.not_to raise_error }

  context "when the user role is data_agent" do
    it "changes the role name to data_viewer" do
      user.role = "data_agent"
      user.save(validate: false)

      expect { run_rake_task }.to change { user.reload.role }.to("data_viewer")
    end
  end

  context "when the user role is admin_agent" do
    it "changes the role name to customer_service_adviser" do
      user.role = "admin_agent"
      user.save(validate: false)

      expect { run_rake_task }.to change { user.reload.role }.to("customer_service_adviser")
    end
  end
end
