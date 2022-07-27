# frozen_string_literal: true

class RemoveNcccEmailService < ::WasteExemptionsEngine::BaseService
  def run
    Registration.where("contact_email ~* ?", "cy.gov.uk").update_all(contact_email: nil)
    Registration.where("applicant_email ~* ?", "cy.gov.uk").update_all(applicant_email: nil)
  end
end
