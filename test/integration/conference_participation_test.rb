require 'integration_test_helper'

class ConferenceParticipationTest < ActionDispatch::IntegrationTest

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Login', :with => @user.email
    fill_in 'Password', :with => "hasenbraten"
    click_link_or_button('Sign in')
  end
  
  background do 
    @user = Factory(:user, :password => "hasenbraten", :password_confirmation => "hasenbraten")
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
