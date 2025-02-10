# frozen_string_literal: true

class PrivateBetaAverageTimePerPagesController < ApplicationController
  prepend_before_action :authorize_user

  def index
    @start_date = start_date
    @end_date = end_date
  end

  private

  def start_date
    return nil if params[:start_date].blank?

    Date.parse(params[:start_date])
  end

  def end_date
    return nil if params[:end_date].blank?

    Date.parse(params[:end_date])
  end

  def authorize_user
    authorize! :view_analytics, :all
  end
end
