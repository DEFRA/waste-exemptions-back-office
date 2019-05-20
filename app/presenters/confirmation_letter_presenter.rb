# frozen_string_literal: true

class ConfirmationLetterPresenter < BasePresenter

  def sorted_active_registration_exemptions
    registration_exemptions_with_exemptions.where(state: :active).order(:exemption_id)
  end

  def sorted_deregistered_registration_exemptions
    registration_exemptions_with_exemptions.where("state != ?", :active).order_by_state_then_exemption_id
  end

  def date_of_letter
    Time.now.in_time_zone("London").to_date.to_formatted_s(:day_month_year)
  end

  def submission_date
    submitted_at.to_date.to_formatted_s(:day_month_year)
  end

  def applicant_full_name
    format_name(applicant_first_name, applicant_last_name)
  end

  def contact_full_name
    format_name(contact_first_name, contact_last_name)
  end

  # Provides the full postal address for the letter.
  def postal_address_lines
    [
      contact_full_name,
      operator_name,
      address_lines(contact_address)
    ].flatten!.reject(&:blank?)
  end

  def operator_address_one_liner
    address_lines(operator_address).join(", ")
  end

  def site_address_one_liner
    address_lines(site_address).join(", ")
  end

  def human_business_type
    I18n.t("waste_exemptions_engine.pdfs.certificate.busness_types.#{business_type}")
  end

  def partners
    people.select(&:partner?).each_with_index.map do |person, index|
      {
        label: I18n.t("business_details.partner_enumerator", scope: "confirmation_letter.show", count: index + 1),
        name: format_name(person.first_name, person.last_name)
      }
    end
  end

  def exemption_description(exemption)
    "#{exemption.code}: #{exemption.summary}"
  end

  def registration_exemption_status(registration_exemption)
    display_date = if registration_exemption.state == "active"
                     registration_exemption.expires_on.to_formatted_s(:day_month_year)
                   else
                     registration_exemption.deregistered_on.to_formatted_s(:day_month_year)
                   end

    I18n.t(
      "waste_exemptions.status.#{registration_exemption.state}",
      scope: "confirmation_letter.show",
      display_date: display_date
    )
  end

  private

  def format_name(first_name, last_name)
    "#{first_name} #{last_name}"
  end

  def registration_exemptions_with_exemptions
    registration_exemptions.includes(:exemption)
  end

  def address_lines(address)
    return [] unless address

    address_fields = %i[organisation premises street_address locality city postcode]
    address_fields.map { |field| address.public_send(field) }.reject(&:blank?)
  end

end
