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
    should "find user by username or full_name if is contact" do
    end

    should "find user only by username if user is not contact" do
    end
  end
end
