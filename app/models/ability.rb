# frozen_string_literal: true

class Ability
  include CanCan::Ability

  ACTIONS = {
    activate_or_deactivate_user: [:activate_or_deactivate, User],
    change_role: [:change_role, User],
    create_registration: [:create, WasteExemptionsEngine::Registration],
    create_new_registration: [:create,
                              WasteExemptionsEngine::NewChargedRegistration],
    deregister_exemption: [:deregister, WasteExemptionsEngine::Registration, { active?: true }],
    deregister_registration_exemption: [:deregister, WasteExemptionsEngine::RegistrationExemption, { active?: true }],
    deregister_site: [:deregister, WasteExemptionsEngine::Address, { site_status: "active" }],
    invite_user: [:invite, User],
    manage_charges: %i[manage_charges all],
    manage_feature_toggles: [:manage, WasteExemptionsEngine::FeatureToggle],
    read_quarterly_stats: [:read, Reports::DefraQuarterlyStatsService],
    download_reports: [:read, Reports::Download],
    read_generated_report: [:read, Reports::GeneratedReport],
    read_finance_data_report: [:read_finance_data, Reports::GeneratedReport],
    read_user: [:read, User],
    read_registration: [:read, WasteExemptionsEngine::Registration],
    read_new_registration: [:read,
                            WasteExemptionsEngine::NewChargedRegistration],
    renew_registration: [:renew, WasteExemptionsEngine::Registration],
    reset_transient_registration: [:reset_transient_registrations, WasteExemptionsEngine::Registration],
    send_comms: [:send_comms, WasteExemptionsEngine::Registration],
    update_registration: [:update, WasteExemptionsEngine::Registration],
    update_new_registration: [:update,
                              WasteExemptionsEngine::NewChargedRegistration],
    update_expiry_date: [:update_expiry_date, WasteExemptionsEngine::Registration],
    use_back_office: %i[use_back_office all],
    view_analytics: %i[view_analytics all],
    add_charge_adjustment: [:add_charge_adjustment, WasteExemptionsEngine::Registration],
    add_payment: [:add_payment, WasteExemptionsEngine::Registration],
    reverse_payment: [:reverse_payment, WasteExemptionsEngine::Registration],
    refund_payment: [:refund_payment, WasteExemptionsEngine::Registration],
    writeoff_payment: [:writeoff_payment, WasteExemptionsEngine::Registration],
    mark_as_legacy_bulk_or_linear: [:mark_as_legacy_bulk_or_linear, WasteExemptionsEngine::Registration]
  }.freeze

  # placeholder to be populated by the roles_and_permissions initializer
  ROLE_PERMISSIONS = {} # rubocop:disable Style/MutableConstant

  def initialize(user)
    return if user.blank?

    assign_permissions_based_on_role(user) if user.active?
  end

  private

  def assign_permissions_based_on_role(user)
    ROLE_PERMISSIONS[user.role].each do |permission|
      can(*ACTIONS[permission.to_sym])
    end
  end
end
