# frozen_string_literal: true

module ApplicationHelper
  def format_date(datetime)
    datetime.to_date.to_fs(:day_month_year_slashes)
  end

  def render_markdown(text)
    sanitize(Kramdown::Document.new(text).to_html)
  end
end
