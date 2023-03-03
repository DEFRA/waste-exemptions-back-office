# frozen_string_literal: true

class DeregistrationEmailExportsController < ApplicationController
  def new
    setup_form
  end

  def create
    setup_form

    if @deregistration_email_exports_form.submit(form_attributes)
      flash[:message] = I18n.t(".deregistration_email_exports.notices.export_complete")
      redirect_to root_path
    else
      flash[:error] = I18n.t(".deregistration_email_exports.errors.service_failed")
      render :new
      false
    end
  end

  private

  def setup_form
    authorize! :manage, DeregistrationEmailExportsForm
    @deregistration_email_exports_form = DeregistrationEmailExportsForm.new
  end

  def form_attributes
    params.fetch(:deregistration_email_exports_form, {}).permit(:batch_size)
  end
end
