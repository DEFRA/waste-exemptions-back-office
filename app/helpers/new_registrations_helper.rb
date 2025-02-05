# frozen_string_literal: true

module NewRegistrationsHelper
  def back_path
    params[:back_to].presence || root_path
  end
end
