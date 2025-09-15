# frozen_string_literal: true

class ResetTransientRegistrationsForm
  include ActiveModel::Model

  def initialize(registration)
    @registration = registration
  end

  def submit
    deleted_records = WasteExemptionsEngine::TransientRegistration
                      .includes(%i[transient_addresses transient_people transient_registration_exemptions
                                   site_addresses])
                      .where(reference: @registration.reference).destroy_all
    deleted_records.any?
  end
end
