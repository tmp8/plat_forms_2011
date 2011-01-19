require "test_helper"
require "capybara/rails"

Capybara.default_selector = :css
#Capybara.default_driver = :selenium


def sign_in(user)
  visit new_user_session_path
  
  fill_in 'Login', :with => user.username
  fill_in 'Password', :with => "123456"
  click_link_or_button('user_submit')
end

module ActionController
  class IntegrationTest
    include Capybara
  end
end
