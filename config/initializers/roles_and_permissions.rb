# frozen_string_literal: true

require "csv"
require "roles_and_permissions_loader"

begin
  RolesAndPermissionsLoader.run
rescue StandardError => e
  Airbrake.notify(e, message: "Error loading roles and permissions") if defined?(Airbrake)
end
