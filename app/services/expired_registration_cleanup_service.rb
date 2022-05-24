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
    log_references!
  end

  private

  # registration exemptions that were deregistered (ceased or revoked)
  # or expired over 7 years ago
  def registration_exemptions
    @registration_exemptions ||=
      WasteExemptionsEngine::RegistrationExemption
      .includes(:registration)
      .where("deregistered_at <= ?", date)
      .or(
        WasteExemptionsEngine::RegistrationExemption.expired.where(
          "updated_at <= ?", date
        )
      )
  end

  def registration_ids
    @registration_ids ||= registration_exemptions.map(&:registration_id).uniq
  end

  def log_references!
    Rails.logger.info(
      <<~TEXT
        Expired registrations deleted
        =============================
        #{references}
        =============================
      TEXT
    )
  end

  def references
    @references ||= registration_exemptions
                    .map { |re| re.registration.reference }
                    .uniq
                    .join("\n")
  end

  # returns string in format 2015-05-24
  def date
    @date ||= ENV.fetch("EXPIRED_REGISTRATION_CLEANUP_DATE", 7.years.ago.to_date)
  end

  def clear_registrations!
    WasteExemptionsEngine::Registration
      .where(id: registration_ids)
      .destroy_all
  end

  # Versions are auto created by the paper_trail gem
  def clear_versions!
    PaperTrail::Version
      .where(
        item_type: "WasteExemptionsEngine::Registration",
        item_id: registration_ids
      ).delete_all
  end

  # archive_versions exist because of a schema change and has no model backing it.
  # see: https://github.com/DEFRA/waste-exemptions-engine/pull/218
  def clear_versions_archive!
    ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        DELETE FROM version_archives
        WHERE item_type = 'WasteExemptionsEngine::Registration'
        AND item_id IN (#{registration_ids.join(', ')})
      SQL
    )
  end
end
