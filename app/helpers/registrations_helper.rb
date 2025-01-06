# frozen_string_literal: true

module RegistrationsHelper
  def applicant_data_present?(resource)
    [resource.applicant_first_name,
     resource.applicant_last_name,
     resource.applicant_phone,
     resource.applicant_email].any?
  end

  def contact_data_present?(resource)
    [resource.contact_first_name,
     resource.contact_last_name,
     resource.contact_phone,
     resource.contact_email,
     resource.contact_position].any?
  end

  def renewal_history(resource)
    result = [resource]
    registration_cursor = resource

    while registration_cursor.renewal?
      registration_cursor = registration_cursor.referring_registration
      result << registration_cursor
    end

    result
  end

  def registration_date_range(resource)
    "(#{resource.created_at.strftime('%-d %B %Y')} to #{resource.expires_on.strftime('%-d %B %Y')})"
  end

  def registration_details_link_with_dates(resource)
    link_text = "#{resource.reference} #{registration_date_range(resource)}"

    link_to link_text, view_link_for(resource), id: "view_#{resource.reference}"
  end
end
