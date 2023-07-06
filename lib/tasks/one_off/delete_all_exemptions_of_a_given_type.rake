# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-2321
  desc "Cease all exemptions of a given type"
  task :delete_all_exemptions_of_a_given_type, %i[exemption_code cease_message] => [:environment] do |_task, args|

    exemption_code = args[:exemption_code]
    cease_message = args[:cease_message]

    abort "exemption_code not specified, aborting rake task" if exemption_code.blank?
    abort "cease_message not specified, aborting rake task" if cease_message.blank?

    exemption_to_cease = WasteExemptionsEngine::Exemption.find_by(code: exemption_code)

    # 1) delete all transient registrations with this exemption
    # Do this first to take these registration exemptions out of scope for step 2
    transient_registration_ids = WasteExemptionsEngine::TransientRegistrationExemption
                                 .where(exemption: exemption_to_cease)
                                 .pluck(:transient_registration_id)

    transient_registrations_to_delete = WasteExemptionsEngine::TransientRegistration
                                        .where(id: transient_registration_ids)

    puts "Deleting #{transient_registrations_to_delete.count} transient registrations" unless Rails.env.test?

    transient_registrations_to_delete.destroy_all

    # 2) cease all active registration_exemptions with this exemption
    registration_exemptions = WasteExemptionsEngine::RegistrationExemption.active.where(exemption: exemption_to_cease)

    puts "Processing #{registration_exemptions.count} registrations" unless Rails.env.test?

    registration_exemptions.update(
      state: "ceased",
      deregistration_message: cease_message,
      deregistered_at: Time.zone.today
    )

  end
end
