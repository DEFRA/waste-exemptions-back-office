# frozen_string_literal: true

module CanBeSearchedLikeTelephone
  extend ActiveSupport::Concern

  included do
    scope :search_for_telephone, lambda { |term|

      return if term.blank?

      # Remove any whitespace
      telephone_number = term.gsub(/\s+/, "")
      # Remove any dashes
      telephone_number.gsub!("-", "")

      # Removing the 0 or +44 at the beggining of the number as this is already included in the regex
      # For numbers not starting in either of these the regex will still work as the 0 and +44 is optional
      if telephone_number.start_with?("+44")
        telephone_number.gsub!("+44", "")
      elsif telephone_number.start_with?("0")
        telephone_number.slice!(0)
      end

      # Regex can search for a number with spaces and dashes anywhere and for UK numbers either starting in 0 or +44
      regex = "^(\\+44|0)?[\\s-]*" + telephone_number.scan(/\d/).map { |c| "#{c}[\\s-]*" }.join

      where(
        "contact_phone ~* ?\
          OR applicant_phone ~* ?",
        regex,  # contact_phone
        regex   # applicant_phone
      )
    }
  end
end
