# frozen_string_literal: true

class QuarterlyStatsController < ApplicationController

  def show
    authorize
    render :show, locals: { report: Reports::DefraQuarterlyStatsService.run }
  end

  private

  def authorize
    authorize! :read, Reports::DefraQuarterlyStatsService
  end
end
