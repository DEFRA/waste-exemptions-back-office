# frozen_string_literal: true

class ResendUserInvitesController < ApplicationController
  include CanSetFlashMessages

  before_action :authorize
  before_action :assign_user
  before_action :check_invitation_pending

  def new; end

  def create
    resend_invite

    redirect_to users_url
  end

  private

  def authorize
    authorize! :invite, current_user
  end

  def assign_user
    @user = User.find(params[:id])
  end

  def check_invitation_pending
    redirect_to users_url unless invitation_pending?
  end

  def invitation_pending?
    @user.active? && @user.invitation_token.present? && current_user.can_administer?(@user)
  end

  def resend_invite
    @user.invite!

    flash_success(I18n.t("resend_user_invites.messages.success", email: @user.email))
  rescue StandardError => e
    Airbrake.notify(e, email: @user.email)
    Rails.logger.error "Failed to resend invitation email to user #{@user.id}"

    flash_error(I18n.t("resend_user_invites.messages.failure", email: @user.email),
                I18n.t("resend_user_invites.messages.failure_details"))
  end
end
