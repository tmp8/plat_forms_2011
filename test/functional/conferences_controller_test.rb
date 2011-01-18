require 'test_helper'

class ConferencesControllerTest < ActionController::TestCase
  
  include Devise::TestHelpers
  
  context "ws" do
    
    setup do
      @user = activated_user
      @conference_attributes = Factory.build(:conference).attributes
      @request.env['HTTP_AUTHORIZATION'] = encode_credentials(@user.username, "123456")
    end
    
    should "create conference" do
      post :create, :conference => @conference_attributes, :format => 'json'
      assert_response :success
      assert_equal(@conference_attributes[:name], JSON.parse(response.body)[:name])
    end
    
  end
end
