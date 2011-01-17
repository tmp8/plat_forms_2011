require "test_helper"
require "capybara/rails"

Capybara.default_selector = :css
Capybara.default_driver = :selenium

WebMock.disable_net_connect!(:allow_localhost => true)

module ActionController
  class IntegrationTest
    include Capybara
  end
end
