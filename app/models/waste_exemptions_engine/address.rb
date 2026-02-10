# frozen_string_literal: true

load WasteExemptionsEngine::Engine.root.join("app", "models", "waste_exemptions_engine", "address.rb")

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
      if registration_exemptions.any? { |re| re.state == "active" }
        "active"
      elsif registration_exemptions.any? { |re| re.state == "expired" }
        "expired"
      else
        "deregistered"
      end
    end

    def ceased_or_revoked_exemptions
      registration_exemptions.where(state: %w[ceased revoked]).map(&:exemption).map(&:code).join(", ")
    end
  end
end
