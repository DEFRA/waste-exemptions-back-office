# frozen_string_literal: true

module UsersHelper
  def administrable_user_roles(current_user)
    AdministrableRolesService.call(current_user)
  end
end
