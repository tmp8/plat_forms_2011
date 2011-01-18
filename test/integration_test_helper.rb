require "test_helper"
require "capybara/rails"

Capybara.default_selector = :css
#Capybara.default_driver = :selenium

module ActionController
  class IntegrationTest
    include Capybara
  end
end
