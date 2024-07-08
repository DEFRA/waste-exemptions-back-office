# frozen_string_literal: true

module Reports
  class BackOfficeUserReportPresenter < BasePresenter

    def initialize(model)
      @user = model
      super
    end

    def last_sign_in_at
      @user.last_sign_in_at&.strftime(Time::DATE_FORMATS[:day_month_year_time_slashes])
    end

    def status
      return "Deactivated" if @user.deactivated?
      return "Invitation Sent" if @user.invitation_token.present?

      "Active"
    end

  end
end
