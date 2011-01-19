require 'integration_test_helper'

class ConferenceCreationTest < ActionDispatch::IntegrationTest
  background do 
    @user = Factory(:user)
    @user.skip_confirmation!
    @user.save!
  end
  
  should "allow user to participate" do
    sign_in(@user)
    
    click_link_or_button("add_conference")
    
    fill_in 'Name', :with => 'My cool conference'
    fill_in 'Description', :with => 'My description'
    fill_in 'Location', :with => 'My location'
    
    click_link_or_button("conference_submit")
    
    assert_equal 'My cool conference', find("h1").text
  end
end
