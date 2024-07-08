# frozen_string_literal: true

require "csv"

module Reports
  class UserRoleExportService < WasteExemptionsEngine::BaseService

    COLUMNS = {
      email: "Email",
      role: "Role",
      status: "Status",
      last_sign_in_at: "Last sign-in"
    }.freeze

    def run
      CSV.generate do |csv|
        csv << COLUMNS.values
        users_scope.each do |user|
          csv << present_row(user)
        end
      end
    end

    private

    # Currently all users; putting this in a method to facilitate future filtering e.g. active users only.
    def users_scope
      User.all
    end

    def present_row(user)
      presenter = BackOfficeUserReportPresenter.new(user)
      COLUMNS.map { |k, _v| presenter.send(k) }
    end
  end
end
