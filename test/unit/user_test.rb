require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context "validations" do
    
    setup do
      @user = Factory(:user)
    end
    
    should validate_presence_of(:username)
    should validate_presence_of(:country)
  end
  
end
