# frozen_string_literal: true

class PermitApplicationForm
  include ActiveModel::Model

  attr_accessor :registration, :permit_application_number, :permit_application_status

  validates :permit_application_number, presence: true
  validates :permit_application_status,
            inclusion: { in: WasteExemptionsEngine::Registration::PERMIT_APPLICATION_STATUSES }

  def submit(params)
    self.permit_application_number = params[:permit_application_number]&.strip
    self.permit_application_status = params[:permit_application_status]

    return false unless valid?

    reason_key = registration.permit_application_in_progress? ? "updated" : "marked"

    registration.update(
      permit_application_number: permit_application_number,
      permit_application_status: permit_application_status,
      reason_for_change: I18n.t("permit_application_form.reason_for_change.#{reason_key}")
    )
  end

  def status_options
    status_struct = Struct.new(:id, :name)
    WasteExemptionsEngine::Registration::PERMIT_APPLICATION_STATUSES.map do |status|
      status_struct.new(status, I18n.t("permit_applications.statuses.#{status}"))
    end
  end
end
