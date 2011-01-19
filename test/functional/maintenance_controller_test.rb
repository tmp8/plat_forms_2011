# origin: M
require 'test_helper'

class MaintenanceControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  context "admin" do
    setup do
      @user = Factory(:admin)
      login_with_basic_auth(@user, "admin")
    end
  
    should "reset portal" do
      any_instance_of(Factorydefaults) do |f|
        mock(f).reset
      end
      
      get :reset
      assert_response 204
    end
  
    should "reset portal to initial state" do
      any_instance_of(Factorydefaults) do |f|
        mock(f).load
      end
    
      get :factorydefaults
      assert_response 204
    end
  end
  
  context "not admin user" do
    setup do
      @user = Factory(:user) # not admin
      login_with_basic_auth(@user)
      
      dont_allow(Factorydefaults).new
    end
    
    should "not reset portal" do
      get :reset
      assert_response 403
    end
    
    should "not reset portal to initial state" do
      get :factorydefaults
      assert_response 403
    end
  end
end