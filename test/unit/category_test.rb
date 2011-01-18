require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  context "validations" do
    setup do
      @user = Factory(:category)
    end
    
    should validate_presence_of(:name)
  end

  context "root scope" do
    should "return only root nodes" do
      parent_category = Factory(:category)
      child_category = Factory(:category, :parent => parent_category)
      
      assert_equal [parent_category], Category.root.all
    end
  end
end
