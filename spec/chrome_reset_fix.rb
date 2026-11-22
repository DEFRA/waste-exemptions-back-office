# frozen_string_literal: true

# Chrome 158 rejects origin "*" in Capybara's reset. Clear cookies this way instead.
module ChromeResetFix
  def execute_cdp(cmd, **params)
    return super unless cmd == "Storage.clearDataForOrigin" && params[:origin] == "*"

    super("Network.clearBrowserCookies")
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(ChromeResetFix)
