# frozen_string_literal: true

require "csv"

module Reports
  class DeregistrationEmailBatchSerializer
    include WasteExemptionsEngine::CanHaveCommunicationLog

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
        csv << ["email address", *self.class::ATTRIBUTES]

        registrations_data do |registration_data|
          csv << registration_data
        end
      end
    end

    # rubocop:disable Metrics/MethodLength
    def eligible_registrations_ids
      return @eligible_registrations_ids if @eligible_registrations_ids

      begin
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
              AND r.submitted_at < '#{min_submitted_at}';
        SQL

        @eligible_registrations_ids =
          conn.execute("SELECT id FROM #{TEMP_TABLE_NAME} TABLESAMPLE system_rows(#{email_batch_size})").map do |row|
            row.fetch("id")
          end
      ensure
        ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{TEMP_TABLE_NAME}")
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    def registrations_data
      scope.find_in_batches(batch_size: iteration_batch_size) do |batch|
        batch.each do |registration|
          next if registration.received_comms?(I18n.t("template_labels.deregistration_invitation_email"))

          presenter = RegistrationDeregistrationEmailPresenter.new(registration)

          data = ATTRIBUTES.map do |attribute|
            presenter.public_send(attribute)
          end

          yield [presenter.contact_email, *data] if presenter.contact_email.present?

          if presenter.applicant_email.present? && presenter.contact_email != presenter.applicant_email
            yield [presenter.applicant_email, *data]
          end

          update_communications_log(registration)
        end
      end
    end

    def update_communications_log(registration)
      # NB this may not be scalable. The original one-off batch job used a dedicated
      # attribute and .update_all(deregistration_email_sent_at: timestamp) in the export service.
      registration.communication_logs ||= []
      registration.communication_logs << WasteExemptionsEngine::CommunicationLog.new(
        {
          message_type: "email",
          template_id: "55faba44-2281-47e8-80a3-9ecb7556eb2e",
          template_label: I18n.t("template_labels.deregistration_invitation_email"),
          sent_to: registration.contact_email
        }
      )
    end

    def iteration_batch_size
      WasteExemptionsBackOffice::Application.config.export_batch_size.to_i
    end

    def scope
      WasteExemptionsEngine::Registration.where(id: eligible_registrations_ids)
    end

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
