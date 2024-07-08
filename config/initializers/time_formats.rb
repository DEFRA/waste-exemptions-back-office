# frozen_string_literal: true

Time::DATE_FORMATS[:day_month_and_time] = "%-d %B at %-l:%M%P"
Time::DATE_FORMATS[:day_month_year_time_slashes] = "%d/%m/%Y %H:%M"
Date::DATE_FORMATS[:month_year] = "%B %Y"
Date::DATE_FORMATS[:abbr_day_month] = "%-d %b"
Date::DATE_FORMATS[:day_month_year] = "%-d %B %Y"
Date::DATE_FORMATS[:abbr_week_day_month] = "%a %-d %b"
Date::DATE_FORMATS[:year_month_day] = "%Y-%m-%d"
Date::DATE_FORMATS[:plain_year_month_day] = "%Y%m%d"
