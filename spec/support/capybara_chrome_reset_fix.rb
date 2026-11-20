# frozen_string_literal: true

# Chrome 158+ rejects origin "*" in Storage.clearDataForOrigin, which Capybara 3.40.0
# sends in ChromeDriver#reset!. Clear cookies via Network.clearBrowserCookies instead.
# Remove once Capybara ships a fix.
module CapybaraChromeResetFix
  private

  def execute_cdp(cmd, params = {})
    return super unless cmd == "Storage.clearDataForOrigin" && params[:origin] == "*"

    super("Network.clearBrowserCookies")
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(CapybaraChromeResetFix)
