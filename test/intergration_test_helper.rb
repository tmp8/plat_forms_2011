require "test_helper"
require "capybara/rails"

Capybara.default_selector = :css

module ActionController
  class IntegrationTest
    include Capybara
  end
end
