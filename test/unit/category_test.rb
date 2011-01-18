require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  context "validations" do
    should validate_presence_of(:name)
  end

  should "return self_with_ancestors" do
    root = Factory(:category)
    sub = Factory(:category, :parent => root)
    sub2 = Factory(:category, :parent => root)
    sub_sub = Factory(:category, :parent => sub)
    
    assert_equal [root, sub, sub2, sub_sub].sort_by(&:id), root.self_with_ancestors.sort_by(&:id)
    assert_equal [sub, sub_sub].sort_by(&:id), sub.self_with_ancestors.sort_by(&:id)
  end

  context "root scope" do
    should "return only root nodes" do
      parent_category = Factory(:category)
      child_category = Factory(:category, :parent => parent_category)
      
      assert_equal [parent_category], Category.root.all
    end
  end
end
