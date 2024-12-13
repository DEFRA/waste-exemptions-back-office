# frozen_string_literal: true

module UsersHelper
  def current_user_group_roles(current_user)
    UserGroupRolesService.call(current_user)
  end
end
