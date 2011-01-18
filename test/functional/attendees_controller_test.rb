require 'test_helper'

class AttendeesControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  
  context "ws" do
    
    setup do
      User.delete_all
      @user = create_activated_user
      @conference = Factory(:conference, :organizator => @user)
      @request.env['HTTP_AUTHORIZATION'] = encode_credentials(@user.username, "123456")
    end
    
    context "index" do
      
      should "return attendees" do
        @conference.participants = 2.times.map { Factory(:user )}
        get :index, :conference_id => @conference.id, :format => "json"
        assert_response :success
        assert_equal 2, JSON.parse(response.body).size
      end
      
      should "return 204 for conference without attendees" do
        get :index, :conference_id => @conference.id, :format => "json"
        assert_response 204
      end
      
      should "return 404" do
        get :index, :conference_id => 2352930, :format => "json"
        assert_response 404
      end
    end
    
    context "create" do
      
      should "return 204 for successful subscription" do
        post :create, {:conference_id => @conference.id, :attendee => {:username => @user.username }.to_json, :format => "json"}
        assert_response 204
        assert_equal [@user], @conference.participants
      end
      
      should "return 403 when given user is not equal with current_user" do
        other_user = Factory(:user)
        post :create, {:conference_id => @conference.id, :attendee => {:username => other_user.username }.to_json, :format => "json"}
        assert_response 403 
      end
    
      should "return 404" do
        post :create, :conference_id => 2352930, :format => "json"
        assert_response 404
      end
    end
    
    context "destroy" do
      
      should "return 204 for successful destroyed subscription" do
        @conference.participants << @user
        post :destroy, {:conference_id => @conference.id, :id => @user.username, :format => "json"}
        assert_equal [], @conference.reload.participants
        assert_equal [@user], User.all
        assert_response 204
      end
      
      should "return 403 when given user is not equal with current_user" do
        other_user = Factory(:user)
        post :destroy, {:conference_id => @conference.id, :id => other_user.username, :format => "json"}
        assert_response 403 
      end
    
      should "return 404" do
        post :destroy, :conference_id => 2352930, :id => "hase", :format => "json"
        assert_response 404
      end
    end
  end
end
