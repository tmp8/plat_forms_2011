require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  setup do 
    @user = Factory(:user)
  end

  test "return just the username if current_user returns nil" do
    stub(self).current_user { nil }
    assert_equal @user.username, user_info(@user)
  end

  test "return fullname and email if current_user is a friend" do
    current_user = mock(User.new).friend_state(@user) { User::IN_CONTACT }
    stub(self).current_user { current_user }
    assert_equal "#{@user.full_name} (#{@user.email})", user_info(@user)
  end
  
  test "return fullname and email if current_user" do
    stub(self).current_user { @user }
    assert_equal "#{@user.full_name} (#{@user.email})", user_info(@user)
  end
end
