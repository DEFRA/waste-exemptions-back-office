# frozen_string_literal: true

# Deletes a single registration (and all of its linked records) identified by its
# reference, but ONLY when it has no registration exemptions. Returns a symbol
# describing the outcome: :deleted, :not_found or :has_exemptions.
class DeleteRegistrationWithoutExemptionsService < WasteExemptionsEngine::BaseService
  def run(reference:)
    @registration = WasteExemptionsEngine::Registration.find_by(reference: reference.to_s.strip)

    return :not_found if @registration.nil?
    return :has_exemptions if @registration.registration_exemptions.any?

    delete_registration
    :deleted
  end

  private

  def delete_registration
    ActiveRecord::Base.transaction do
      # paper_trail would otherwise create a version for the deletion
      PaperTrail.request(enabled: false) do
        @registration.destroy!
      end
      clear_versions!
      clear_versions_archive!
    end
  end

  def clear_versions!
    PaperTrail::Version
      .where(item_type: "WasteExemptionsEngine::Registration", item_id: @registration.id)
      .delete_all
  end

  def clear_versions_archive!
    ActiveRecord::Base.connection.execute(
      <<~SQL.squish
        DELETE FROM version_archives
        WHERE item_type = 'WasteExemptionsEngine::Registration'
        AND item_id = #{@registration.id}
      SQL
    )
  end
end
