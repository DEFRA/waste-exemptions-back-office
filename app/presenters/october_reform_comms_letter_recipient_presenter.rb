# frozen_string_literal: true

# The contact name and address of a registration, as used for the October reform comms letters
class OctoberReformCommsLetterRecipientPresenter < BasePresenter
  # For displayable_address()
  include WasteExemptionsEngine::ApplicationHelper

  def first_name
    contact_first_name.to_s.squish
  end

  def last_name
    contact_last_name.to_s.squish
  end

  def address_lines
    displayable_address(contact_address).map(&:squish)
  end

  def recipient
    ["#{first_name} #{last_name}", *address_lines].join(", ")
  end
end
