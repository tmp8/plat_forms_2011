class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Category'
  has_many :sub_categories, :class_name => 'Category', :foreign_key => 'parent_id'

  def self_with_ancestors
    [self, sub_categories.map(&:self_with_ancestors)].flatten
  end
end
