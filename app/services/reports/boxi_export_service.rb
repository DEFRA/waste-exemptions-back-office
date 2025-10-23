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

        save_metadata_to_db
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

    def file_name
      "waste_exemptions_rep_daily_full.zip"
    end

    def file_path
      @file_path ||= Rails.root.join("tmp/#{file_name}")
    end

    def bucket_name
      WasteExemptionsBackOffice::Application.config.boxi_exports_bucket_name
    end

    def save_metadata_to_db
      report = GeneratedReport.find_or_create_by!(report_type: GeneratedReport::REPORT_TYPE_BOXI)
      report.file_name = file_name
      report.data_from_date = "2018-01-01"
      report.data_to_date = Time.zone.today

      report.save! if report.changed?
    end
  end
end
