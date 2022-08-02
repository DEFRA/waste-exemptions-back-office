# frozen_string_literal: true

# rubocop:disable Layout/LineLength
class RemoveNcccEmailService < ::WasteExemptionsEngine::BaseService

  # https://rubular.com/r/LPHA79nxD5k2ff
  # rubocop:disable Style/StringLiterals
  WASTE_EXEMPTIONS_EMAIL_VARIATIONS = '^(w|a)[qaste]?\w{2,}(-?(e|-)|)(.?e)\w{7,}@(e|a|n)\w{5,17}(.|-)(ag?(ency|ancy|ncy)|gov).(gov.uk|uk)'

  EXEMPTION_EMAIL_VARIATIONS = '^e(nquiries|xcemption?(s|)|xceptions|xemptions)@environment-agency.gov.uk'

  NCCC_EMAIL_VARIATIONS = '^nccc(-?[cew]\w{4,}(-\w{10,}@|@)|@)enviro\w{4,}-agency.gov.uk'
  # rubocop:enable Style/StringLiterals

  def run
    clean_up_applicant_email
    clean_up_contact_email
  end

  def clean_up_applicant_email
    matching_registrations = find_email_variations(:applicant_email)
    return unless matching_registrations.any?

    Rails.logger.info "Clearing wex applicant email addresses: #{matching_registrations.pluck(:applicant_email)}"
    matching_registrations.update_all(applicant_email: nil)
  end

  def clean_up_contact_email
    matching_registrations = find_email_variations(:contact_email)
    return unless matching_registrations.any?

    Rails.logger.info "Clearing wex contact email addresses: #{matching_registrations.pluck(:contact_email)}"
    matching_registrations.update_all(contact_email: nil)
  end

  def find_email_variations(email_type)
    WasteExemptionsEngine::Registration.where("#{email_type} ~* ? or #{email_type} ~* ? or #{email_type} ~* ?", WASTE_EXEMPTIONS_EMAIL_VARIATIONS, EXEMPTION_EMAIL_VARIATIONS, NCCC_EMAIL_VARIATIONS)
  end
  # rubocop:enable Layout/LineLength
end
