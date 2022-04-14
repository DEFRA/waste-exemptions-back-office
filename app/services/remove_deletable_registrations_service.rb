# frozen_string_literal: true

class RemoveDeletableRegistrationsService < ::WasteExemptionsEngine::BaseService
  def run
    log "========================"
    PaperTrail.enabled = false
    remove_registrations_deregistered_over_seven_years_ago
    PaperTrail.enabled = true
    log "========================"
  end

  private

  def remove_registrations_deregistered_over_seven_years_ago
    log "Starting removal of registrations deregistered over 7 years ago"

    registration_exemptions_deregistered_over_seven_years_ago.find_each do |registration_exemption|
      remove_registration(registration_exemption)
    end

    log "Removal completed"
  end

  def registration_exemptions_deregistered_over_seven_years_ago
    WasteExemptionsEngine::RegistrationExemption
      .includes(:registration)
      .where("deregistered_at < ?", 7.years.ago)
  end

  def remove_registration(registration_exemption)
    registration = registration_exemption.registration
    paper_trail_versions = registration.versions

    registration.destroy

    paper_trail_versions.delete_all

    log "Removed registration: #{registration.reference}"
  end

  def log(msg)
    # Avoid cluttering up the test logs
    puts msg unless Rails.env.test?
  end
end
