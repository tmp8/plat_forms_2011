# origin: M
require 'integration_test_helper'

class ConferenceCreationTest < ActionDispatch::IntegrationTest
  background do 
    @user = Factory(:user)
    @user.skip_confirmation!
    @user.save!
  end
  
  setup do
    sign_in(@user)
    create_conference('My cool conference', 'My description', 'My location')
  end
  
  teardown do
    click_link_or_button('sign_out')
  end
  
  should "allow user to create conference" do
    assert_equal 'My cool conference', find("h1").text
  end
    
  should "allow creator to edit conference" do
    click_link_or_button("conference_edit")
    fill_in 'Name', :with => 'My cool conference 2'
    click_link_or_button("conference_submit")
    assert_equal 'My cool conference 2', find("h1").text
  end
  
  def create_conference(name, description, location)
    click_link_or_button("add_conference")
    
    fill_in 'Name', :with => name
    fill_in 'Description', :with => description
    fill_in 'Location', :with => location
    
    click_link_or_button("conference_submit")
  end
end
