# frozen_string_literal: true

class SendEditInviteEmailsController < ApplicationController
  def new
    @resource = WasteExemptionsEngine::Registration.find(params[:id])
    @resource.regenerate_and_timestamp_edit_token

    authorize! :send_edit_invite_email, @resource

    if WasteExemptionsEngine::RegistrationEditLinkEmailService.run(
      registration: @resource,
      recipient: @resource.contact_email,
      magic_link_token: @resource.edit_token
    )
      flash[:message] = I18n.t(".send_edit_invite_emails.flash.success")
    else
      flash[:error] = I18n.t(".send_edit_invite_emails.flash.failure")
    end

    redirect_back fallback_location: root_path
  end
end
