# origin: M

require 'test_helper'

class ConferenceParticipationTest < ActiveSupport::TestCase
  
  background do
    @user = Factory(:user)
    @conference = Factory(:conference)
  end
  
  should "be able to attend a conference" do
    participation = @user.attend!(@conference)

    assert_equal [@user], @conference.participants
    assert_equal [@conference], @user.conferences
    assert_equal participation,  @user.participation_for(@conference)
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
    @user.reload
    
    assert_equal [], @conference.participants
    assert_equal [], @user.conferences
    assert_equal nil,  @user.participation_for(@conference)
  end
  
  should "not be able to attend a conference in the past"
end
