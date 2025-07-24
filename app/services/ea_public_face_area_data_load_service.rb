# frozen_string_literal: true

require "zip"

class EaPublicFaceAreaDataLoadService < WasteExemptionsEngine::BaseService
  def run
    geo_json = read_areas_file
    features = RGeo::GeoJSON.decode(geo_json)

    ActiveRecord::Base.transaction do
      features.each { |feature| process_feature(feature) }
    end
  end

  private

  def process_feature(feature)
    return if feature.properties["seaward"] == "Yes"

    attributes = {
      name: feature.properties["long_name"],
      area_id: feature.properties["identifier"],
      area: feature.geometry
    }

    area = WasteExemptionsEngine::EaPublicFaceArea.where(code: feature.properties["code"]).first

    if area.present?
      area.update(attributes)
      puts "Updated EA Public Face Area \"#{area.code}\" (#{area.name})" unless Rails.env.test? # rubocop:disable Rails/Output
    else
      area = WasteExemptionsEngine::EaPublicFaceArea.create(attributes.merge(code: feature.properties["code"]))
      puts "Created EA Public Face Area \"#{area.code}\" (#{area.name})" unless Rails.env.test? # rubocop:disable Rails/Output
    end
  end

  def read_areas_file
    Zip::File.open(zipfile_path) do |zip_file|
      zip_file.glob(areas_filename)
              .first
              .get_input_stream
              .read
    end
  end

  def zipfile_path
    Rails.root.join("lib/fixtures/#{areas_filename}.zip")
  end

  def areas_filename
    "Administrative_Boundaries_Environment_Agency_and_Natural_England_Public_Face_Areas.json"
  end
end
