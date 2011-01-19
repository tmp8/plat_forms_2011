# origin: M
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context "validations" do
    
    setup do
      @user = Factory(:user)
    end
    
    should validate_presence_of(:full_name)
    should validate_presence_of(:email)
    should validate_presence_of(:username)
    should validate_presence_of(:city)
    should validate_presence_of(:country)
    should validate_uniqueness_of :username
  end
  
  context "query" do
    background do 
      @admin = Factory(:user, :username => "admin", :full_name => "root")
      @thies = Factory(:user, :username => "thies", :full_name => "joshua arntzen")
      @lurker = Factory(:user)
      @admin.request_friendship(@thies).confirm!
    end
    
    should "find user by full_name if friend" do
      assert_equal [@thies], User.find_by_term("joshua", @admin)
    end

    should "not find user by full_name if NOT friend" do
      assert_equal [], User.find_by_term("joshua", @lurker)
    end

    should "find user by username " do
      assert_equal [@thies], User.find_by_term("thies", @admin)
      assert_equal [@thies], User.find_by_term("thies", @lurker)
    end
    
    should "be friends" do
      assert @admin.friends_with?(@thies)
      assert @thies.friends_with?(@admin)
    end
  end
end
