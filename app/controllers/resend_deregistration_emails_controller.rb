# frozen_string_literal: true

class ResendDeregistrationEmailsController < ApplicationController
  def new
    @resource = WasteExemptionsEngine::Registration.find(params[:id])

    authorize! :resend_registration_email, @resource

    if ResendDeregistrationEmailService.run(registration: @resource)
      flash[:message] = I18n.t(".resend_deregistration_emails.flash.success")
    else
      flash[:error] = I18n.t(".resend_deregistration_emails.flash.failure")
    end

    redirect_back fallback_location: root_path
  end
end
