#origin M

require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  
  context "ws" do
    
    setup do
      User.delete_all
      @user = Factory(:user)
      @category = Factory(:category)
      login_with_basic_auth(@user)
    end
    
    context "by category" do
      setup do
        @other_category = Factory(:category)
        @conference, @other_conference = 2.times.map { Factory(:conference) }
        @other_category.conferences << @other_conference
        @category.conferences << @conference
      end
      
      should "find conference for category" do
        get :conferences, :id => @category.id
        assert_response :success
        conferences = JSON.parse(response.body)
        assert_equal 1, conferences.size
        assert_equal @conference.id, conferences.first["id"]
      end
      
      should "find conference for category" do
        @category.conferences.destroy_all
        get :conferences, :id => @category.id
        assert_response 204
      end
      
      should "return 404" do
        get :conferences, :id => 350923, :format => "json"
        assert_response 404
        assert_equal "application/json", response.content_type
      end
    end
    
    context "index" do
      
      should "return categories" do
        get :index, :format => "json"
        assert_response :success
        categories = JSON.parse(response.body)
        assert_equal 1, categories.size
        assert_equal @category.name, categories.first["name"]
        assert_equal "application/json", response.content_type
      end
      
      should "respond with 204 on blank categories" do
        Category.delete_all
        get :index, :format => "json"
        assert_response 204
        assert_equal "application/json", response.content_type
      end
    end
    
    context "show" do
      
      should "return category object" do
        get :show, :id => @category.id, :format => "json"
        assert_response :success
        assert_equal "application/json", response.content_type
        assert_equal @category.name, JSON.parse(response.body)["name"]
      end
      
      should "return 404" do
        get :show, :id => 350923, :format => "json"
        assert_response 404
        assert_equal "application/json", response.content_type
      end
    end
    
    context "create" do
      
      context "admin" do
        
        setup do
          @admin = Factory(:admin)
          login_with_basic_auth(@admin, "admin")
        end
        
        should "create category" do
          assert_difference("Category.count") do
            raw_post :create, {:format => "json"}, {:name => "mycategory"}.to_json
          end
          assert_response :success
          assert_equal "application/json", response.content_type
          assert_equal "mycategory", JSON.parse(response.body)["name"]
        end
        
        should "return 400 for invalid category" do
          assert_no_difference("Category.count") do
            raw_post :create, {:format => "json"}, {:other_attr => "mycategory"}.to_json
          end
          assert_response 400
          assert_equal "application/json", response.content_type
        end
      end
      
      context "normal user" do
        
        should "be forbidden to create category" do
          assert_no_difference("Category.count") do
            raw_post :create, {:format => "json"}, {:name => "mycategory"}.to_json
          end
          assert_response 403
        end
      end
    end   
  end
end