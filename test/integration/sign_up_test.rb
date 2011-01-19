require 'integration_test_helper'

class SignUpTest < ActionDispatch::IntegrationTest

  should "allow user to participate" do
    visit new_user_registration_path
    
  end
end
