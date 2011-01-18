# origin: M

require 'test_helper'

class ConferenceParticipationTest < ActiveSupport::TestCase
  
  background do
    @user = Factory(:user)
    @conference = Factory(:conference)
  end
  
  should "be able to attend a conference" do
    @user.attend!(@conference)
    assert_equal [@user], @conference.participants

    assert_equal [@conference], @user.conferences
  end

  should "now be able to attend a conference twice" do
    @user.attend!(@conference)
    assert_no_difference('ConferenceParticipation.count') do
      @user.attend!(@conference)
    end   
  end
  
  should "be able to cancel his participation in conference" do
    @user.attend!(@conference)
    @user.wont_attend!(@conference)
    assert_equal [], @user.conferences
  end
  
  should "not be able to attend a conference in the past"
end
