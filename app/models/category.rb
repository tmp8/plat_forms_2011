class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Category'
  has_many :sub_categories, :class_name => 'Category', :foreign_key => 'parent_id'
  
  has_many :conference_categories
  has_many :conferences, :through => :conference_categories
  
  scope :root, :conditions => 'parent_id is NULL'
  
  validates_presence_of :name
  
  def conferences_including_subs(conferences = [])
    conferences << self.conferences
    sub_categories.each { |category| category.conferences_including_subs(conferences) }
    conferences.flatten.uniq
  end

  def self_with_ancestors
    [self, sub_categories.map(&:self_with_ancestors)].flatten
  end
end
