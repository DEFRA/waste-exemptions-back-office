# frozen_string_literal: true

class AdministrableRolesService
  def self.call(user)
    case user.role
    when "admin_team_user" # Waste Exemptions Administration Team User
      admin_team_user_roles
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

  def self.admin_team_user_roles
    %w[admin_team_user
       customer_service_adviser
       data_viewer]
  end

  def self.service_manager_roles
    %w[customer_service_adviser
       data_viewer
       finance_user
       developer
       service_manager
       admin_team_user
       admin_team_lead
       policy_advisor]
  end

  def self.admin_team_lead_roles
    %w[customer_service_adviser
       data_viewer
       finance_user
       developer
       service_manager
       admin_team_user
       admin_team_lead
       policy_advisor]
  end

  def self.policy_adviser_roles
    %w[policy_advisor
       data_viewer]
  end
end
