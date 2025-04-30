# frozen_string_literal: true

require "hashdiff"

class AuditTrailDiffService < WasteExemptionsEngine::BaseService

  FIELDS_TO_EXCUDE = %w[created_at updated_at id edit_token view_certificate_token_created_at edit_token_created_at
                        reason_for_change].freeze

  @older_version = nil
  @newer_version = nil

  def run(older_version_json:, newer_version_json:)
    @older_version = json_to_hash(older_version_json)
    @newer_version = json_to_hash(newer_version_json)

    diff = hash_diff(@older_version, @newer_version)
    build_change_log(diff)
  end

  private

  def reduce(object)
    return object unless object.is_a?(Hash) || object.is_a?(Array)

    object.is_a?(Hash) ? reduce_hash(object) : reduce_array(object)
  end

  def reduce_hash(hash)
    hash.compact.transform_values { |value| reduce(value) }
  end

  def reduce_array(array)
    if array.first.is_a?(Hash) && array.first.key?("address_type")
      array.index_by { |a| a["address_type"] || SecureRandom.uuid }
    else
      array.map { |a| reduce(a) }
    end
  end

  def json_to_hash(json_str)
    return {} if json_str.blank?

    data = JSON.parse(json_str).to_h
    filtered_data = remove_unnecessary_fields(data)
    reduce(filtered_data)
  end

  def remove_unnecessary_fields(data)
    case data
    when Hash
      data.except(*FIELDS_TO_EXCUDE)
          .transform_values { |v| remove_unnecessary_fields(v) }
    when Array
      data.map { |v| remove_unnecessary_fields(v) }
    else
      data
    end
  end

  def hash_diff(previous_version, updated_version)
    Hashdiff.diff(previous_version, updated_version)
  end

  def build_change_log(changes)
    changes.each_with_object([]) do |change, updates|
      update_row = build_change_entry(change)
      updates << update_row if update_row.present? && updates.none? { |x| x[1] == update_row[1] }
    end
  end

  def build_change_entry(change)
    change_type, identifier, data, additional = change

    if identifier.include?("addresses.")
      process_address_change(identifier)
    else
      process_generic_change(change_type, identifier, data, additional)
    end
  end

  def process_address_change(identifier)
    address_type = identifier.split(".")[1]
    older_address_text = address_hash_to_text(@older_version.dig("addresses", address_type))
    newer_address_text = address_hash_to_text(@newer_version.dig("addresses", address_type))

    column_identifier = identifier.split(".").first(2).join(".")
    generate_update_row(column_identifier, older_address_text, newer_address_text)
  end

  def process_generic_change(change_type, identifier, data, additional)
    previous_value, new_value = case change_type
                                when "+"
                                  ["", data]
                                when "-"
                                  [data, ""]
                                when "~"
                                  [data, additional]
                                else
                                  Rails.logger.error("Unknown change type: #{change_type}")
                                  Airbrake.notify "Unknown change type", { change_type: change_type }
                                end

    generate_update_row(identifier, previous_value, new_value)
  end

  def generate_update_row(identifier, previous_value, new_value)
    return nil if previous_value.blank? && new_value.blank?
    return nil if previous_value == new_value

    if previous_value.blank? # Value added
      ["+", identifier, previous_value, new_value]
    elsif new_value.blank? # Value removed
      ["-", identifier, previous_value, new_value]
    else # Value changed
      ["~", identifier, previous_value, new_value]
    end
  end

  def address_hash_to_text(address_hash)
    return "" if address_hash.blank?

    case address_hash["mode"]
    when "lookup", "manual"
      address_hash.values_at("organisation", "premises", "street_address", "city", "postcode").compact.join("\n")
    when "auto"
      address_hash.values_at("grid_reference", "description").compact.join("\n")
    else
      ""
    end
  end
end
