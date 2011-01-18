class Series < ActiveRecord::Base
  has_many :conferences
  has_many :series_contacts, :dependent => :destroy
  has_many :contacts, :through => :series_contacts
end
