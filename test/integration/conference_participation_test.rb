require 'integration_test_helper'

class ConferenceParticipationTest < ActionDispatch::IntegrationTest

  background do 
    @user = Factory(:user)
    @user.skip_confirmation!
    @user.save!
    
    @conference = Factory(:conference)
  end
  
  should "allow user to participate" do
    sign_in(@user)
    visit conference_path(@conference)
    click_link_or_button("Attend!")
    click_link_or_button("Won't attend!")
    click_link_or_button("Attend!")
  end
end
