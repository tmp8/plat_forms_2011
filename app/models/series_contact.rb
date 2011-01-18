class SeriesContact < ActiveRecord::Base
  belongs_to :series
  belongs_to :contact, :class_name => 'User', :foreign_key => :contact_id
end
