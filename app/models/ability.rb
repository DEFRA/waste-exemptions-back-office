# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    assign_permissions_based_on_role(user) if user.active?
  end

  private

  def assign_permissions_based_on_role(user)
    permissions_for_system_user if user.role_is?(:system)
    permissions_for_super_agent if user.role_is?(:super_agent)
    permissions_for_admin_agent if user.role_is?(:admin_agent)
    permissions_for_data_agent if user.role_is?(:data_agent)
    permissions_for_developer if user.role_is?(:developer)
  end

  def permissions_for_system_user
    can :invite, User
    can :read, User
    can :change_role, User
    can :activate_or_deactivate, User
    can :read, Reports::DefraQuarterlyStatsService

    permissions_for_super_agent
  end

  def permissions_for_super_agent
    can :update, WasteExemptionsEngine::Registration
    can :deregister, WasteExemptionsEngine::Registration, &:active?
    can :deregister, WasteExemptionsEngine::RegistrationExemption, &:active?

    permissions_for_admin_agent
  end

  def permissions_for_admin_agent
    can :renew, WasteExemptionsEngine::Registration
    can :create, WasteExemptionsEngine::Registration
    can :resend_registration_email, WasteExemptionsEngine::Registration
    can :create, WasteExemptionsEngine::NewRegistration
    can :update, WasteExemptionsEngine::NewRegistration

    permissions_for_data_agent
  end

  def permissions_for_data_agent
    can :use_back_office, :all
    can :read, WasteExemptionsEngine::Registration
    can :read, WasteExemptionsEngine::NewRegistration
    can :read, Reports::GeneratedReport
  end

  # Developer users should just be those on the current delivery team and/or
  # those providing system support. We allow the same permissions as an admin
  # agent as they will often need to interact with the service including
  # creating exemptions in order to test and debug.
  def permissions_for_developer
    permissions_for_admin_agent

    can :manage, WasteExemptionsEngine::FeatureToggle
    can :manage, DeregistrationEmailExportsForm
    can :read, Reports::DefraQuarterlyStatsService
  end
end
