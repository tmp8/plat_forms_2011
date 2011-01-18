class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Category'
  has_many :sub_categories, :class_name => 'Category', :foreign_key => 'parent_id'
end
