require 'test_helper'

class ConferencesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  context "ical" do
    should "export conference as ical" do
      sign_in(Factory(:user))
      
      conference = Factory(:conference)
      get :ical, :conference_id => conference.id
      
      assert_match /BEGIN:VCALENDAR/, response.body
    end
  end
  
  context "ws" do
    
    setup do
      Conference.delete_all
      @user = Factory(:user)
      @conference_attributes = Factory.build(:conference).attributes
      login_with_basic_auth(@user)
    end
    
    context "index" do
        
      should "create simple conference" do
        raw_post :create, {:format => 'json'}, @conference_attributes.to_json
        assert_response :success
        assert_equal(@conference_attributes[:name], JSON.parse(response.body)[:name])
        assert_equal [Conference.first], @user.organizing_conferences
        assert_equal "application/json", response.content_type
      end
    
      should "create conference with categories" do
        category = Factory(:category)
        conference_attributes_with_category = @conference_attributes.merge(:categories => [{:name => category.name}])
        raw_post :create, {:format => "json"}, conference_attributes_with_category.to_json
        assert_response :success
        assert_equal [category], Conference.first.categories
        assert_equal "application/json", response.content_type
      end
          
      should "respond with 400 on false request" do
        raw_post :create, {:format => "json"}, {:hallo => "123"}.to_json
        assert_response 400
        assert_equal "application/json", response.content_type
      end
    end
      
    context "show" do
        
      setup do
        @conference = Factory(:conference)
      end
      
      should "return confernce by id" do
        get :show, :id => @conference.id, :format => "json"
        assert_equal @conference.id, JSON.parse(response.body)["id"]
        assert_equal "application/json", response.content_type
      end
      
      should "return 404" do
        get :show, :id => 342355, :format => "json"
        assert_response 404
        assert_equal "application/json", response.content_type
      end
    end
    
    context "update" do
      
      setup do
        @conference = Factory(:conference, :organizator => @user)
      end
      
      should "update conference" do
        raw_post :update, {:format => "json", :id => @conference.id, :method => "put"}, { :name => "updated name" }.to_json
        assert_response :success
        assert_equal "application/json", response.content_type
        assert_nothing_raised { JSON.parse(response.body) }
        assert_equal "updated name", @conference.reload.name
      end
      
      should "return 404" do
        raw_post :update, {:format => "json", :method => "put", :id => 342355}, {}.to_json
        assert_equal "application/json", response.content_type
        assert_response 404
      end
    end
  end
end
