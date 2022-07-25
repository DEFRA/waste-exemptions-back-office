# frozen_string_literal: true

class RemoveNcccEmailService < ::WasteExemptionsEngine::BaseService
  def run
    contact_emails = find_nccc_email_in_contact_email
    return unless contact_emails.present? && contact_emails.any?

    contact_emails.each do |email|
      email.contact_email = nil
      email.save!
    end

    # @applicant_email.each do |email|
    #   email.applicant_email = nil
    #   email.applicant_email.save!
    # end
  end
  # Change find by on line 23 to a regular expression , look at batch updates for the database

  private

  def find_nccc_email_in_contact_email
    WasteExemptionsEngine::Registration.find_by(contact_email: "waste-exemptions@environment-agency.gov.uk")
  end

  # def find_nccc_email_in_applicant_email
  #   @applicant_emails ||=
  #     WasteExemptionsEngine::Registration.find_by(applicant_email: "waste-exemptions@environment-agency.gov.uk")
  # end

  # def NCCC_email_variations
  #   @NCCC_email_variations = ["waste-exemptions@environment-agency.gov.uk", "nccc@environment-agency.gov.uk"]
  # end
end