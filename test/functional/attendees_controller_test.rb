#origin M

require 'test_helper'

class AttendeesControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  
  context "ws" do
    
    setup do
      User.delete_all
      @user = Factory(:user)
      @conference = Factory(:conference, :organizator => @user)
      login_with_basic_auth(@user)
    end
    
    context "index" do
      
      should "return attendees" do
        @conference.participants = 2.times.map { Factory(:user )}
        get :index, :conference_id => @conference.id, :format => "json"
        assert_response :success
        assert_equal 2, JSON.parse(response.body).size
        assert_equal "application/json", response.content_type
      end
      
      should "return 204 for conference without attendees" do
        get :index, :conference_id => @conference.id, :format => "json"
        assert_response 204
        assert_equal "application/json", response.content_type
      end
      
      should "return 404" do
        get :index, :conference_id => 2352930, :format => "json"
        assert_equal "application/json", response.content_type
        assert_response 404
      end
    end
    
    context "create" do
      
      should "return 204 for successful subscription" do
        raw_post :create, {:conference_id => @conference.id, :format => "json"}, {:username => @user.username }.to_json
        assert_response 204
        assert_equal [@user], @conference.participants
        assert_equal "application/json", response.content_type
      end
      
      should "return 403 when given user is not equal with current_user" do
        other_user = Factory(:user)
        raw_post :create,  {:conference_id => @conference.id, :format => "json"}, {:username => other_user.username }.to_json
        assert_response 403 
        assert_equal "application/json", response.content_type
      end
    
      should "return 404" do
        post :create, :conference_id => 2352930, :format => "json"
        assert_response 404
        assert_equal "application/json", response.content_type
      end
    end
    
    context "destroy" do
      
      should "return 204 for successful destroyed subscription" do
        @conference.participants << @user
        post :destroy, {:conference_id => @conference.id, :id => @user.username, :format => "json"}
        assert_equal [], @conference.reload.participants
        assert_equal "application/json", response.content_type
        assert_response 204
      end
      
      should "return 403 when given user is not equal with current_user" do
        other_user = Factory(:user)
        post :destroy, {:conference_id => @conference.id, :id => other_user.username, :format => "json"}
        assert_equal "application/json", response.content_type
        assert_response 403 
      end
    
      should "return 404" do
        post :destroy, :conference_id => 2352930, :id => "hase", :format => "json"
        assert_equal "application/json", response.content_type
        assert_response 404
      end
    end
  end
end
