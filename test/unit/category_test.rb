require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  should "return self_with_ancestors" do
    root = Factory(:category)
    sub = Factory(:category, :parent => root)
    sub2 = Factory(:category, :parent => root)
    sub_sub = Factory(:category, :parent => sub)
    
    assert_equal [root, sub, sub2, sub_sub].sort_by(&:id), root.self_with_ancestors.sort_by(&:id)
    assert_equal [sub, sub_sub].sort_by(&:id), sub.self_with_ancestors.sort_by(&:id)
  end
end
