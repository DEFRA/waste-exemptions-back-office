# frozen_string_literal: true

require "rails_helper"

module Reports

  ALL_ROLES = %w[
    admin_agent
    data_agent
    developer
    system
    service_manager
    admin_team_lead
  ].freeze

  RSpec.describe UserRoleExportService do
    describe ".run" do
      subject(:csv_export) { described_class.run }

      let(:all_rows) { csv_export.split("\n") }
      let(:headers) { all_rows.first.split(",") }
      let(:content_rows) { all_rows[1..] }

      let(:email_column_index) { headers.index("Email") }
      let(:email_column_values) { content_rows.map { |row| row.split(",")[email_column_index] } }

      let(:last_sign_in_time) { 1.day.ago }
      let(:last_sign_in_column_index) { headers.index("Last sign-in") }

      before do
        Reports::ALL_ROLES.each { |role| create(:user, role) }
        create(:user, :admin_agent, :inactive, last_sign_in_at: nil)
      end

      def row_for_user(user)
        content_rows.select { |row| row.split(",").first == user.email }.first
      end

      it "includes the expected columns" do
        expect(headers).to eq ["Email", "Role", "Status", "Last sign-in"]
      end

      it "includes all active users" do
        User.where(active: true).find_each do |active_user|
          expect(email_column_values).to include(active_user.email)
        end
      end

      it "includes all inactive users" do
        User.where(active: false).find_each do |inactive_user|
          expect(email_column_values).to include(inactive_user.email)
        end
      end

      context "with a user who has not yet logged in" do
        let(:not_logged_in_user) { create(:user, :admin_agent, last_sign_in_at: nil) }

        it { expect(row_for_user(not_logged_in_user).split(",")[last_sign_in_column_index]).to be_nil }
      end

      context "with a user who has logged in" do
        let(:logged_in_user) { create(:user, :admin_agent, last_sign_in_at: last_sign_in_time) }

        it do
          expect(row_for_user(logged_in_user).split(",")[last_sign_in_column_index])
            .to eq(last_sign_in_time.strftime("%d/%m/%Y %H:%M"))
        end
      end
    end
  end
end
