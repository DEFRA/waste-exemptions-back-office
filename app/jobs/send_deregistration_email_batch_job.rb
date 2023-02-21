# frozen_string_literal: true

class SendDeregistrationEmailBatchJob < ApplicationJob
  TEMP_TABLE_NAME = "deregisterable_registration_ids"

  def perform
    return unless WasteExemptionsEngine::FeatureToggle.active?(:send_deregistration_emails)

    eligible_registrations_ids.each do |registration_id|
      SendDeregistrationEmailJob.perform_later(registration_id)
    end
  end

  private

  # Retrieve a set of registration ids each taken from random page files of the
  # registrations table.
  #
  # IDs are picked from a temporary table containing only deregistion-email
  # eligible registrations using block-level sampling. This works well for our
  # use-case of selecting large (1000+) amounts of regisrations, but may be
  # less reliable for expected randomness if a small sample is taken.
  #
  # See also: https://www.postgresql.org/docs/current/tsm-system-rows.html
  def eligible_registrations_ids
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

    conn.execute("SELECT id FROM #{TEMP_TABLE_NAME} TABLESAMPLE system_rows(#{batch_size})").map do |row|
      row.fetch("id")
    end
  ensure
    conn.execute("DROP TABLE IF EXISTS #{TEMP_TABLE_NAME}")
  end

  def batch_size
    Rails.configuration.registration_email_batch_size
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
