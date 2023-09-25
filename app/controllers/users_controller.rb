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
    render :index
  end
end
