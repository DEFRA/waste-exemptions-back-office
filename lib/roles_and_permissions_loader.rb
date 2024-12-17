# frozen_string_literal: true

# Used by the roles_and_permissions initializer to load roles and permissions
# from a CSV file. Separated out from the initializer to allow unit testing.

class RolesAndPermissionsLoader
  def self.run
    csv = load_csv

    role_permissions = roles_from_csv(csv)

    raise StandardError, "Roles and permissions not loaded" if role_permissions.empty?

    update_ability(role_permissions)
  rescue StandardError => e
    Airbrake.notify(e, message: "RolesAndPermissionsLoader error") if defined? Airbrake
    Rails.logger.error "RolesAndPermissionsLoader failed: #{e}" if Rails.respond_to?(:logger)
  end

  def self.load_csv
    CSV.parse(Rails.root.join("lib/fixtures/roles_and_permissions.csv").read,
              headers: true,
              header_converters: ->(f) { f.strip },
              converters: ->(f) { f&.strip })
  end

  def self.roles_from_csv(csv)
    roles = csv.headers[1..]
    role_permissions = roles.index_with { |_role| [] }

    csv.each do |row|
      roles.each do |role|
        role_permissions[role] << row["permission"] if row[role].upcase == "Y"
      end
    end

    role_permissions
  end

  def self.update_ability(role_permissions)
    if Rails.initialized?
      Ability::ROLE_PERMISSIONS.replace role_permissions
    else
      # Ensure the Ability model is loaded when this is called from the initializer:
      Rails.application.config.to_prepare { Ability::ROLE_PERMISSIONS.replace role_permissions }
    end
  end
end
