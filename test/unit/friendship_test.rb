# origin: M

require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  background do
    @user = Factory(:user)
    @friend = Factory(:user)
  end
  
  should "connect friends" do
    assert_equal User::NO_CONTACT, @user.friend_state(@friend)
    assert_equal User::NO_CONTACT, @friend.friend_state(@user)
    
    @user.request_friendship(@friend)

    @friend.reload
    @user.reload

    assert_equal User::RCD_SENT, @user.friend_state(@friend)
    assert_equal User::RCD_RECEIVED, @friend.friend_state(@user)

    assert_equal 1, @user.friendship_requests.size
    assert_equal 1, @friend.friendship_invitations.size

    @friend.friendship_invitations.first.confirm!
    
    @friend.reload
    @user.reload

    assert_equal User::IN_CONTACT, @user.friend_state(@friend)
    assert_equal User::IN_CONTACT, @friend.friend_state(@user)

    assert_equal 0, @user.friendship_requests.size
    assert_equal 0, @friend.friendship_invitations.size

    assert_equal [@friend], @user.friends
    assert_equal [@user], @friend.friends
  end
  
  should "not create new outstandig requests if exists or blocked"

  should "delete request if reject!" do
    assert_no_difference('Friendship.count') do
      @user.request_friendship(@friend)
      @friend.friendship_invitations.first.reject!
    end   
    
    assert_equal User::NO_CONTACT, @user.friend_state(@friend)
    assert_equal User::NO_CONTACT, @friend.friend_state(@user)
  end
end
