# frozen_string_literal: true

class SendEditInviteEmailsController < ApplicationController
  def new
    @resource = WasteExemptionsEngine::Registration.find(params[:id])
    @resource.regenerate_and_timestamp_edit_token

    authorize! :send_comms, @resource

    if @resource.contact_email.blank?
      flash[:error] = I18n.t(".send_edit_invite_emails.flash.no_contact_email.error")
      flash[:error_details] = I18n.t(".send_edit_invite_emails.flash.no_contact_email.details")
      redirect_back_or_to(root_path) and return
    end

    if WasteExemptionsEngine::RegistrationEditLinkEmailService.run(
      registration: @resource,
      recipient: @resource.contact_email,
      magic_link_token: @resource.edit_token
    )
      flash[:message] = I18n.t(".send_edit_invite_emails.flash.success")
    else
      flash[:error] = I18n.t(".send_edit_invite_emails.flash.failure")
    end

    redirect_back_or_to(root_path)
  end
end
