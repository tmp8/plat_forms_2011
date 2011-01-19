#origin: M

require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  context "ws" do
    
    setup do
      User.delete_all
      @user = Factory(:user)
      login_with_basic_auth(@user)
      @friend, @requesting_friend, @requested_friend, @no_friend = 4.times.map { Factory(:user) }
      make_friends(@user, @friend)
      @user.request_friendship(@requested_friend)
      @requesting_friend.request_friendship(@user)
    end
    
    context "index" do
      
      should "return full contacts" do
        get :index, :user_id => @user.username, :format => "json"
        assert_response :success
        assert_equal "application/json", response.content_type
        json_friends = JSON.parse(response.body)
        assert_equal 3, json_friends.size
        
        friend_names = json_friends.map {|e| e["username"]}
        assert friend_names.include?(@friend.username)
        assert friend_names.include?(@requesting_friend.username)
        assert friend_names.include?(@requested_friend.username)
      end
      
      should "return only public contacts (friends)" do
        login_with_basic_auth(@friend)
        get :index, :user_id => @user.username, :format => "json"
        assert_response :success
        assert_equal "application/json", response.content_type
        json_friends = JSON.parse(response.body)
        assert_equal 1, json_friends.size
        assert_equal @friend.username, json_friends.first["username"]
      end
      
      should "return 404" do
        get :index, :user_id => "not exsting user", :format => "json"
        assert_response 404
        assert_equal "application/json", response.content_type
      end
      
      should "return 204 on blank contacts" do
        get :index, :user_id => @requesting_friend.username, :format => "json"
        assert_response 204
        assert_equal "application/json", response.content_type
        assert_equal [], JSON.parse(response.body)
      end
    end
  
    context "create" do
      
      should "confirm a friendship request" do
        raw_post :create, {:user_id => @requesting_friend.username, :format => "json" }, {:positive => true}.to_json
        assert_equal User::IN_CONTACT, @user.reload.friend_state(@requesting_friend)
        assert_response 204
        assert_equal "application/json", response.content_type        
      end
      
      should "reject a friendship request" do
        raw_post :create, {:user_id => @requesting_friend.username, :format => "json" }, {:positive => false}.to_json
        assert_equal User::NO_CONTACT, @user.reload.friend_state(@requesting_friend)
        assert_response 204        
        assert_equal "application/json", response.content_type        
      end
      
      should "do nothing when already friends" do
        raw_post :create, {:user_id => @friend.username, :format => "json" }, {:positive => false}.to_json
        assert_equal User::IN_CONTACT, @user.reload.friend_state(@friend)
        assert_response 204        
        assert_equal "application/json", response.content_type
      end
      
      should "do nothing on self friends" do
        raw_post :create, {:user_id => @user.username, :format => "json" }, {:positive => false}.to_json
        assert_equal User::IN_CONTACT, @user.reload.friend_state(@user)
        assert_response 204        
        assert_equal "application/json", response.content_type
      end
      
      should "send a friendship request to foreign user" do
        raw_post :create, {:user_id => @no_friend.username, :format => "json" }, {:positive => true}.to_json
        assert_equal User::RCD_SENT, @user.reload.friend_state(@no_friend)
        assert_response 204
        assert_equal "application/json", response.content_type
      end
      
      should "do nothing when send a friendship request to existing friend" do
        raw_post :create, {:user_id => @friend.username, :format => "json" }, {:positive => true}.to_json
        assert_equal User::IN_CONTACT, @user.reload.friend_state(@friend)
        assert_response 204
        assert_equal "application/json", response.content_type
      end
      
      should "return 404 on invalid user" do
        raw_post :create, {:user_id => "not existing user", :format => "json" }, {:positive => true}.to_json
        assert_response 404
        assert_equal "application/json", response.content_type
      end
      
      should "return 400 on invalid params value" do
        raw_post :create, {:user_id => @friend.username, :format => "json" }, {:positive => "tralaa"}.to_json
        assert_response 400
        assert_equal "application/json", response.content_type
      end
      
      should "return 400 on invalid params key" do
        raw_post :create, {:user_id => @friend.username, :format => "json" }, {:trala => "true"}.to_json
        assert_response 400
        assert_equal "application/json", response.content_type
      end
    end
  end
  
  private
    def make_friends(user, friend)
      user.request_friendship(friend)
      friend.friendship_invitations.outstanding.first.confirm!
    end
end