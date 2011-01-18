require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context "validations" do
    
    setup do
      @user = Factory(:user)
    end
    
    should validate_presence_of(:username)
    should validate_presence_of(:country)
  end
  
  context "associations" do
    
    setup do
      @user = Factory(:user)
    end
    
    should have_many(:organizing_conferences)
  end
  
end
