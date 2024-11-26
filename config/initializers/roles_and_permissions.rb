# frozen_string_literal: true

require "csv"
# require "ability"

Rails.application.config.to_prepare do
  raw_content = Rails.root.join("lib/fixtures/roles_and_permissions.csv").read
  csv = CSV.parse(raw_content,
                  headers: true,
                  header_converters: ->(f) { f.strip },
                  converters: ->(f) { f&.strip })

  roles = csv.headers[1..]
  role_permissions = roles.index_with { |_role| [] }

  csv.each do |row|
    roles.each do |role|
      role_permissions[role] << row["permission"] if row[role].upcase == "Y"
    end
  end

  original_verbose = $VERBOSE
  $VERBOSE = nil # suppress warning about already-initialized constant

  Ability::ROLE_PERMISSIONS = role_permissions

  $VERBOSE = original_verbose
end
