# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMailer do
  let(:token) { "abcde12345" }
  let(:user) { build(:user, :system, email: "grace.hopper@example.com", invitation_token: token, invitation_created_at: Time.zone.now) }

  describe "invitation_instructions" do
    let(:mail) { described_class.invitation_instructions(user, token) }

    it "sets the correct template ID and personalisation" do
      expect(mail[:template_id].to_s).to eq("9e1bad58-4c99-432a-920e-c82715c5cbdc")
      expect(mail[:personalisation].unparsed_value).to have_key(:account_email)
      expect(mail[:personalisation].unparsed_value[:account_email]).to eq("grace.hopper@example.com")
      expect(mail[:personalisation].unparsed_value).to have_key(:invite_link)
      expect(mail[:personalisation].unparsed_value[:invite_link]).to \
        include("/users/invitation/accept?invitation_token=abcde12345")
    end

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(I18n.t("user_mailer.invitation_instructions.subject"))
      expect(mail.from).to eq([described_class.default[:from]])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("You have been invited to set up a back office account")
      expect(mail.body.encoded).to include("/users/invitation/accept?invitation_token=abcde12345")
      expect(mail.body.encoded).to match(I18n.t("devise.mailer.invitation_instructions.paragraph_3", due_date: I18n.l(user.invitation_created_at + 2.weeks, format: :accept_until_format)))
      expect(mail.body.encoded).to match(I18n.t("devise.mailer.invitation_instructions.paragraph_4"))
    end
  end

  describe "reset_password_instructions" do
    let(:mail) { described_class.reset_password_instructions(user, token) }

    it "sets the correct template ID and personalisation" do
      expect(mail[:template_id].to_s).to eq("42866e99-d364-4ac9-ba41-d292ad136752")
      expect(mail[:personalisation].unparsed_value).to have_key(:account_email)
      expect(mail[:personalisation].unparsed_value[:account_email]).to eq("grace.hopper@example.com")
      expect(mail[:personalisation].unparsed_value).to have_key(:change_password_link)
      expect(mail[:personalisation].unparsed_value[:change_password_link]).to \
        include("/users/password/edit?reset_password_token=abcde12345")
    end

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(I18n.t("user_mailer.reset_password_instructions.subject"))
      expect(mail.from).to eq([described_class.default[:from]])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("requested a link to change your password")
      expect(mail.body.encoded).to include("/users/password/edit?reset_password_token=abcde12345")
      expect(mail.body.encoded).to match("Your password will not change until you access the link above and create a new one")
    end
  end

  describe "unlock_instructions" do
    let(:mail) { described_class.unlock_instructions(user, token) }

    it "sets the correct template ID and personalisation" do
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(I18n.t("devise.mailer.unlock_instructions.subject"))
      expect(mail[:template_id].to_s).to eq("5435d4ee-d983-4cd8-b0be-707cec220f87")
      expect(mail[:personalisation].unparsed_value).to have_key(:account_email)
      expect(mail[:personalisation].unparsed_value[:account_email]).to eq("grace.hopper@example.com")
      expect(mail[:personalisation].unparsed_value).to have_key(:unlock_url)
      expect(mail[:personalisation].unparsed_value[:unlock_url]).to include("/users/unlock?unlock_token=abcde12345")
    end

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(I18n.t("devise.mailer.unlock_instructions.subject"))
      expect(mail.from).to eq([described_class.default[:from]])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your account has been locked")
      expect(mail.body.encoded).to include("/users/unlock?unlock_token=abcde12345")
      expect(mail.body.encoded).to match("Click the link below to unlock")
    end
  end
end
