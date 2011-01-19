#origin: M
class Category < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Category'
  has_many :sub_categories, :class_name => 'Category', :foreign_key => 'parent_id'
  
  has_many :conference_categories
  has_many :conferences, :through => :conference_categories
  
  scope :root, :conditions => 'parent_id is NULL'
  
  validates_presence_of :name
  
  class << self
    def for_select
      all.map { |cat| [cat.full_name, cat.id ] }.sort_by { |c| c[0] }
    end
  end
  
  def conferences_including_subs(conferences = [])
    conferences << self.conferences
    sub_categories.each { |category| category.conferences_including_subs(conferences) }
    conferences.flatten.uniq
  end
  
  def full_name
    if parent 
      "#{parent.full_name} : #{name}"
    else
      name
    end
  end
  
  def self_with_ancestors
    [self, sub_categories.map(&:self_with_ancestors)].flatten
  end
end
