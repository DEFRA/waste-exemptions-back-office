# frozen_string_literal: true

# Chrome sometimes reports an element that a page load has just replaced as a generic error, rather
# than the "stale element" one Capybara knows to retry, which fails a feature spec at random.
# Retrying on this error too lets Capybara find the element again on the new page.
module RetryStaleElements
  def invalid_element_errors
    super + [::Selenium::WebDriver::Error::UnknownError]
  end
end

Capybara::Selenium::Driver.prepend(RetryStaleElements)
