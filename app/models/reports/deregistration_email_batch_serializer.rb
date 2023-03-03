# frozen_string_literal: true

require "csv"

module Reports
  class DeregistrationEmailBatchSerializer
    TEMP_TABLE_NAME = "deregisterable_registration_ids"

    ATTRIBUTES = %i[
      contact_name
      site_details
      reference
      magic_link_url
      exemption_details
    ].freeze

    attr_reader :registration, :email_batch_size

    def initialize(batch_size: Rails.configuration.registration_email_batch_size)
      @email_batch_size = batch_size
    end

    def to_csv
      CSV.generate do |csv|
        csv << [:email, *self.class::ATTRIBUTES]

        registrations_data do |registration_data|
          csv << registration_data
        end
      end
    end

    private

    def registrations_data
      scope.find_in_batches(batch_size: iteration_batch_size) do |batch|
        batch.each do |registration|
          presenter = RegistrationDeregistrationEmailPresenter.new(registration)

          data = ATTRIBUTES.map do |attribute|
            presenter.public_send(attribute)
          end

          yield [presenter.contact_email, *data]

          yield [presenter.applicant_email, *data] if presenter.contact_email != presenter.applicant_email
        end
      end
    end

    def iteration_batch_size
      WasteExemptionsBackOffice::Application.config.export_batch_size.to_i
    end

    def scope
      WasteExemptionsEngine::Registration.where(id: eligible_registrations_ids)
    end

    # rubocop:disable Metrics/MethodLength
    def eligible_registrations_ids
      return @eligible_registrations_ids if @eligible_registrations_ids

      conn = ActiveRecord::Base.connection

      conn.execute("DROP TABLE IF EXISTS #{TEMP_TABLE_NAME}")

      conn.execute <<-SQL.squish
        CREATE TEMP TABLE #{TEMP_TABLE_NAME} AS
          SELECT DISTINCT r.id AS id
            FROM registrations r
                LEFT JOIN registration_exemptions rex
                    ON r.id = rex.registration_id
                    AND rex.state = 'active'
                    AND rex.expires_on - interval '#{renewal_window} days' > '#{today}'
          WHERE rex.id IS NOT NULL
            AND r.submitted_at < '#{min_submitted_at}'
            AND r.deregistration_email_sent_at IS NULL;
      SQL

      @eligible_registrations_ids =
        conn.execute("SELECT id FROM #{TEMP_TABLE_NAME} TABLESAMPLE system_rows(#{email_batch_size})").map do |row|
          row.fetch("id")
        end
    ensure
      conn.execute("DROP TABLE IF EXISTS #{TEMP_TABLE_NAME}")
    end
    # rubocop:enable Metrics/MethodLength

    def renewal_window
      WasteExemptionsEngine.configuration.renewal_window_before_expiry_in_days.to_i
    end

    def min_submitted_at
      Time.zone.today - Rails.configuration.registration_email_batch_minimum_age_days.to_i.days
    end

    def today
      Date.current.to_s
    end
  end
end
