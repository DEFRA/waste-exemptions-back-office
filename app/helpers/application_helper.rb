# frozen_string_literal: true

module ApplicationHelper
  def format_date(datetime)
    datetime.to_date.to_fs(:day_month_year_slashes)
  end

  def render_markdown(text)
    markdown = text.gsub(/(?<!\n)\n(?!\n)/, "  \n")

    sanitize(Kramdown::Document.new(markdown).to_html)
  end
end
