require 'test_helper'

class ConferencesControllerTest < ActionController::TestCase
   
  context "ws" do
    
    setup do
      @user = activated_user
      @conference_attributes = Factory.build(:conference).attributes
    end
    
    should "create conference" do
      basic_authenticated_user(@user.username)
      post :create, :conference => @conference_attributes
    end
  end
  
end
