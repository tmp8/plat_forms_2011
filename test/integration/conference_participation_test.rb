require 'integration_test_helper'

class ConferenceParticipationTest < ActionDispatch::IntegrationTest

  background do 
    @user = Factory(:user)
    @user.confirmed_at = Time.now 
    @user.save!
    
    @conference = Factory(:conference)
  end
  
  should "allow user to participate" do
    sign_in(@user)
    visit conference_path(@conference)
    click_link_or_button("Attend")
    click_link_or_button("Wont attend")
    click_link_or_button("Attend")
  end
end
