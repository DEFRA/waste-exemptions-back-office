# frozen_string_literal: true

class ExpiredRegistrationCleanupService < ::WasteExemptionsEngine::BaseService
  def run
    return unless registration_ids.any?

    ActiveRecord::Base.transaction do
      # paper_trail will try creating a record for the deletion
      # unless we execute within this block
      PaperTrail.request(enabled: false) do
        clear_registrations!
      end
      clear_versions!
      clear_versions_archive!
    end
  end

  private

  # registration exemptions that were deregistered (ceased or revoked)
  # or expired over 7 years ago
  def registration_ids
    @registration_ids ||=
      WasteExemptionsEngine::RegistrationExemption
      .where(
        <<~SQL
          deregistered_at <= '#{date}'
          OR (state = 'expired' AND updated_at <= '#{date}')
        SQL
      )
      .pluck(:registration_id)
      .uniq
  end

  def date
    @date ||= 7.years.ago.to_date
  end

  def clear_registrations!
    WasteExemptionsEngine::Registration
      .where(id: registration_ids)
      .destroy_all
  end

  # Versions are auto created by the paper_trail gem
  def clear_versions!
    ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        DELETE FROM versions
        WHERE item_type = 'WasteExemptionsEngine::Registration'
        AND item_id IN #{registration_ids_sql}
      SQL
    )
  end

  # archive_versions exist because of a schema change
  # see: https://github.com/DEFRA/waste-exemptions-engine/pull/218
  def clear_versions_archive!
    ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        DELETE FROM version_archives
        WHERE item_type = 'WasteExemptionsEngine::Registration'
        AND item_id IN #{registration_ids_sql}
      SQL
    )
  end

  def registration_ids_sql
    @registration_ids_sql ||= "(#{registration_ids.join(', ')})"
  end
end
