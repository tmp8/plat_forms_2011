#origin: M

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  context "ws" do
    
    setup do
      User.delete_all
      @user = Factory(:user)
      @conference = Factory(:conference, :organizator => @user)
      login_with_basic_auth(@user)
    end
    
    context "create" do
      
      setup do
        ActionMailer::Base.deliveries = []
        @user_attributes = Factory.attributes_for(:user, :username => "hans")
      end
      
      should "create user" do
        assert_difference("User.count") do
          raw_post :create, {:format => "json"}, @user_attributes.to_json
        end
        assert_equal [], ActionMailer::Base.deliveries
        assert_equal "application/json", response.content_type
        assert_response :success
        assert_equal "hans", JSON.parse(response.body)["username"]
      end
      
      should "return 400 with invalid data" do
        assert_no_difference("User.count") do
          invalid_attributes = @user_attributes.merge(:password => "not_matching_with_confirmation")
          raw_post :create, {:format => "json"}, invalid_attributes.to_json
          assert_response 400
          assert_equal "application/json", response.content_type
        end
      end
    end
    
    context "show" do
      
      should "return user" do
        get :show, :id => @user.username, :format => "json"
        assert_response :success
        assert_equal "application/json", response.content_type
        assert_equal @user.username, JSON.parse(response.body)["username"]
      end
      
      should "return 404" do
        get :show, :id => "not existing user", :format => "json"
        assert_response 404
        assert_equal "application/json", response.content_type
      end
    end
    
    
    context "update" do
      
      should "return user" do
        raw_post :update, {:format => "json", :id => @user.username}, {:username => "changed_username"}.to_json
        assert_response :success
        assert_equal "application/json", response.content_type
        assert_equal "changed_username", JSON.parse(response.body)["username"]
      end
      
      should "return 404" do
        username = @user.username
        raw_post :update, {:format => "json", :id => "not existing user"}, {:username => "changed_username"}.to_json
        assert_response 404
        assert_equal "application/json", response.content_type
        assert_equal username, @user.reload.username
      end
      
      should "return 400 bad request on invalid data" do
        other_username = Factory(:user).username
        username = @user.username
        raw_post :update, {:format => "json", :id => @user.username}, {:username => other_username}.to_json
        assert_response 400
        assert_equal "application/json", response.content_type
        assert_equal username, @user.reload.username
      end
      
      should "not allow to update other users" do
        username = @user.username
        other_user = Factory(:user)
        raw_post :update, {:format => "json", :id => other_user.username}, {:username => "changed_username"}.to_json
        assert_response 403
        assert_equal "application/json", response.content_type
        assert_equal username, @user.reload.username
      end
    end        
  end
end