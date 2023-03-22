# frozen_string_literal: true

require_relative "../concerns/can_load_file_to_aws"

module Reports
  class DeregistrationEmailBatchExportService < WasteExemptionsEngine::BaseService
    include CanLoadFileToAws

    attr_reader :batch_size

    def run(batch_size:)
      @batch_size = batch_size

      populate_temp_file

      options = { s3_directory: "Deregistrations" }

      load_file_to_aws_bucket(options)

      # We want to update the timestamp on the exported registrations in one
      # SQL statement without running validations on 1000+ rows - hence we
      # explicitly allow #update_all here:
      #
      # rubocop:disable Rails/SkipsModelValidations
      WasteExemptionsEngine::Registration
        .where(id: serializer.eligible_registrations_ids)
        .update_all(deregistration_email_sent_at: timestamp)
      # rubocop:enable Rails/SkipsModelValidations

      true
    rescue StandardError => e
      Airbrake.notify e, file_name: file_name
      Rails.logger.error "Generate deregistration email batch export csv error for #{file_name}:\n#{e}"
      false
    ensure
      File.unlink(file_path)
    end

    private

    def populate_temp_file
      File.write(file_path, serializer.to_csv)
    end

    def file_path
      Rails.root.join("tmp/#{file_name}.csv")
    end

    def file_name
      @file_name ||= "#{timestamp.utc.to_s.split.join('_')}-#{batch_size}"
    end

    def serializer
      @serializer ||= DeregistrationEmailBatchSerializer.new(batch_size: batch_size)
    end

    def timestamp
      @timestamp ||= Time.zone.now
    end

    def bucket_name
      WasteExemptionsBackOffice::Application.config.deregistration_email_bucket_name
    end
  end
end
