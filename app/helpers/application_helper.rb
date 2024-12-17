# frozen_string_literal: true

module ApplicationHelper
  def format_date(datetime)
    datetime.to_date.to_fs(:day_month_year_slashes)
  end
end
