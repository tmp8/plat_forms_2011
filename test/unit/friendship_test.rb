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

    assert_equal 1, @user.friendships.outstanding.size
    assert_equal 1, @friend.friendship_requests.outstanding.size

    @friend.friendship_requests.first.confirm!
    
    @friend.reload
    @user.reload

    assert_equal User::IN_CONTACT, @user.friend_state(@friend)
    assert_equal User::IN_CONTACT, @friend.friend_state(@user)

    assert_equal [], @user.friendships.outstanding
    assert_equal [], @friend.friendship_requests.outstanding

    assert_equal [@friend], @user.friends
    assert_equal [@user], @friend.friends
  end
  
  should "not create new outstandig requests if exists or blocked"
  should "allow ending a friendship"
  should "allow cancelling a friendship request"

  should "delete request if reject!" do
    assert_no_difference('Friendship.count') do
      @user.request_friendship(@friend)
      @friend.friendship_requests.first.reject!
    end   
    
    assert_equal User::NO_CONTACT, @user.friend_state(@friend)
    assert_equal User::NO_CONTACT, @friend.friend_state(@user)
  end
end
