# frozen_string_literal: true

class UserGroupRolesService
  def self.call(user)
    case user.role
    when "system" # Waste Exemptions Administration Team User
      system_roles
    when "service_manager" # Service Manager
      service_manager_roles
    when "admin_team_lead" # Waste Exemptions Administration Team Leader
      admin_team_lead_roles
    when "policy_adviser" # Waste Exemptions Policy Adviser
      policy_adviser_roles
    else
      []
    end
  end

  def self.system_roles
    %w[system]
  end

  def self.service_manager_roles
    %w[customer_service_adviser
       data_viewer
       finance_user
       developer
       service_manager
       system
       admin_team_lead
       policy_advisor]
  end

  def self.admin_team_lead_roles
    %w[customer_service_adviser
       data_viewer
       system
       admin_team_lead]
  end

  def self.policy_adviser_roles
    %w[policy_advisor
       data_viewer]
  end
end
