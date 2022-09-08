# frozen_string_literal: true

module CanBeSearchedLikeAddress
  extend ActiveSupport::Concern

  included do
    scope :search_for_postcode, lambda { |term|
      where("UPPER(postcode) LIKE ?", "%#{term&.upcase}%")
    }

    scope :site, -> { where(address_type: 3) }
    scope :contact, -> { where(address_type: 2) }
    scope :operator, -> { where(address_type: 1 ) }
  end
end
