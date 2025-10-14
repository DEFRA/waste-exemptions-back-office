# frozen_string_literal: true

require WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "address")

module WasteExemptionsEngine
  class Address
    include CanBeSearchedLikeAddress

    # S9 4WF with an optional space in the middle
    NCCC_POSTCODE_REGEX = "S9 ?4WF"

    scope :nccc, -> { where("postcode ~* '#{NCCC_POSTCODE_REGEX}'") }
    scope :not_nccc, -> { where.not(id: nccc) }

    def reference
      site_suffix.present? ? "#{registration.reference}/#{site_suffix}" : registration.reference
    end

    def site_status
      regexemptions = registration.multisite? ? registration_exemptions : registration.registration_exemptions
      regexemptions.active.any? ? "active" : "deregistered"
    end

    def ceased_or_revoked_exemptions
      if registration.multisite?
        registration_exemptions.where(state: %w[ceased revoked]).map(&:exemption).map(&:code).join(", ")
      else
        registration.registration_exemptions.where(state: %w[ceased revoked]).map(&:exemption).map(&:code).join(", ")
      end
    end
  end
end
