# frozen_string_literal: true

class UserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  include Rails.application.routes.mounted_helpers
  include Devise::Controllers::UrlHelpers

  default from: "registrations@wasteexemptions.service.gov.uk"

  def invitation_instructions(record, token, _opts = {})
    @resource = record
    @email = record.email
    @token = token
    @link = accept_user_invitation_url(invitation_token: token)
    expiry_date = record.invitation_created_at ? I18n.l(record.invitation_created_at + User.invite_for, format: :accept_until_format) : nil

    mail(
      to: @email,
      subject: I18n.t("devise.mailer.invitation_instructions.subject"),
      template_id: "9e1bad58-4c99-432a-920e-c82715c5cbdc",
      personalisation: {
        account_email: @email,
        invite_link: @link,
        link_expiry_date: expiry_date
      }
    )
  end

  def reset_password_instructions(record, token, _opts = {})
    @resource = record
    @email = record.email
    @token = token
    @link = edit_user_password_url(reset_password_token: token)

    mail(
      to: record.email,
      subject: I18n.t("devise.mailer.reset_password_instructions.subject"),
      template_id: "42866e99-d364-4ac9-ba41-d292ad136752",
      personalisation: {
        account_email: @email,
        change_password_link: @link
      }
    )
  end

  def unlock_instructions(record, token, _opts = {})
    @resource = record
    @email = record.email
    @token = token
    @link = user_unlock_url(unlock_token: token)

    mail(
      to: record.email,
      subject: I18n.t("devise.mailer.unlock_instructions.subject"),
      template_id: "5435d4ee-d983-4cd8-b0be-707cec220f87",
      personalisation: {
        account_email: @email,
        unlock_url: @link
      }
    )
  end
end
