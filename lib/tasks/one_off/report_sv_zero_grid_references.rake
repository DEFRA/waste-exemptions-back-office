# frozen_string_literal: true

# Keep the existing report and its history output together in this read-only task.
# rubocop:disable Metrics/BlockLength
namespace :one_off do
  desc "Report SV 00000 00000 site addresses, renewal links and retained site history (read-only)"
  task report_sv_zero_grid_references: :environment do
    addresses = WasteExemptionsEngine::Address.site.where(
      "REGEXP_REPLACE(UPPER(grid_reference), '[[:space:]]+', '', 'g') = ?",
      FixSvZeroGridReferencesService::BAD_GRID_REFERENCE
    ).includes(:registration).order(:id).to_a

    puts "Matching site addresses: #{addresses.size}"

    groups = addresses.group_by { |address| [address.mode, address.postcode.present?, address.uprn.present?] }
    groups.each do |(mode, postcode_present, uprn_present), group|
      puts "mode=#{mode} postcode_present=#{postcode_present} uprn_present=#{uprn_present} count=#{group.size}"
    end

    fields = %i[
      mode grid_reference postcode uprn x y area organisation premises street_address locality city
      description source_data_type created_at
    ]

    addresses.each do |address|
      details = fields.map { |field| "#{field}=#{address.public_send(field).inspect}" }
      puts "registration=#{address.registration&.reference.inspect} address_id=#{address.id} #{details.join(' ')}"
    end

    puts "Renewal links and retained site history (read-only):"
    puts "Chains are newest to oldest; each registration's history is printed once, oldest event first."
    puts "Missing snapshots or authors do not establish how the original grid reference was supplied."
    puts "Legacy before_event snapshots describe the state before a change, not its result."

    registrations = addresses.filter_map(&:registration).uniq(&:id)
    SvZeroGridReferenceHistoryService.run(registrations:).each do |row|
      puts row.to_json
    end
  end
end
# rubocop:enable Metrics/BlockLength
