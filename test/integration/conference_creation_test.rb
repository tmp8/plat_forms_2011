require 'integration_test_helper'

class ConferenceCreationTest < ActionDispatch::IntegrationTest
  background do 
    @user = Factory(:user, :password => "hasenbraten", :password_confirmation => "hasenbraten")
    @user.confirmed_at = Time.now 
    @user.save!
    
    @conference = Factory(:conference)
  end
  
  should "allow user to participate" do
    sign_in(@user)
    visit "/"
    # click_link_or_button("Conference")
    # fill_in
  end
end
