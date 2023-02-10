# frozen_string_literal: true

require "zip"
require_relative "../concerns/can_load_file_to_aws"

module Reports
  class BoxiExportService < WasteExemptionsEngine::BaseService
    include CanLoadFileToAws

    def run
      Dir.mktmpdir do |dir_path|
        Boxi::AddressesSerializer.export_to_file(dir_path)
        Boxi::ExemptionsSerializer.export_to_file(dir_path)
        Boxi::PeopleSerializer.export_to_file(dir_path)
        Boxi::RegistrationExemptionsSerializer.export_to_file(dir_path)
        Boxi::RegistrationsSerializer.export_to_file(dir_path)

        zip_export_files(dir_path)

        load_file_to_aws_bucket
      end
    rescue StandardError => e
      Airbrake.notify e
      Rails.logger.error "Generate BOXI export error:\n#{e}"
    ensure
      # In case of failure before the file is generated
      FileUtils.rm_f(file_path)
    end

    private

    def zip_export_files(dir_path)
      files_search_path = File.join(dir_path, "*.csv")

      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        Dir[files_search_path].each do |export_file_path|
          zipfile.add(File.basename(export_file_path), export_file_path)
        end
      end
    end

    def file_path
      @file_path ||= Rails.root.join("tmp/waste_exemptions_rep_daily_full.zip")
    end

    def bucket_name
      WasteExemptionsBackOffice::Application.config.boxi_exports_bucket_name
    end
  end
end
