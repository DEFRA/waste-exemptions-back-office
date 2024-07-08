# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    authorize! :read, current_user

    @users = User.where(active: true).order(email: :asc).page(params[:page]).per(100)
  end

  def all
    authorize! :read, current_user

    @users = User.order(email: :asc).page(params[:page]).per(100)

    @show_all_users = true

    respond_to do |format|
      format.html do
        render :index
      end

      format.csv do
        timestamp = Time.zone.now.strftime("%Y-%m-%d_%H:%M")
        send_data Reports::UserRoleExportService.run, filename: "users_and_roles_#{timestamp}.csv"
      end
    end
  end
end
