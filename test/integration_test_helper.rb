require "test_helper"
require "capybara/rails"

Capybara.default_selector = :css
#Capybara.default_driver = :selenium


def sign_in(user)
  visit new_user_session_path
  fill_in 'Email', :with => @user.email
  fill_in 'Password', :with => "hasenbraten"
  click_link_or_button('Sign in')
end

module ActionController
  class IntegrationTest
    include Capybara
  end
end
