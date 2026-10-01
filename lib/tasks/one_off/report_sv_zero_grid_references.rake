# frozen_string_literal: true

namespace :one_off do
  desc "Report site addresses with an SV 00000 00000 grid reference"
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
  end
end
